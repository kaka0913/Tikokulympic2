import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    @Published var image: UIImage? = nil
    private var isLoading = false
    
    func loadImage(userid: String) {
        // すでに画像をロード済みの場合は再ロードしない
        guard !isLoading else { return }
        isLoading = true
        
        Task {
            do {
                let data = try await SupabaseService().downloadProfileImage(userid: userid)
                if let downloadedImage = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.image = downloadedImage
                        self.isLoading = false
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    print("画像のダウンロードに失敗しました: \(error.localizedDescription)")
                    self.isLoading = false
                }
            }
        }
    }
}
