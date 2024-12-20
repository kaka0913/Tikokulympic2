//
//  ProfileImageView.swift
//  TikokulympicBeta
//
//  Created by 株丹優一郎 on 2024/09/28.
//

import SwiftUI

struct ProfileImageView: View {
    @State private var uploadedImage: UIImage? = nil
    @State private var isDownloading: Bool = false
    @State private var errorMessage: String = ""
    
    private let supabaseService = SupabaseService.shared
    let userid: String
    var FrameSize: CGFloat = 50

    var body: some View {
        VStack {
            if let image = uploadedImage {
                
                Image(uiImage: image)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: FrameSize, height: FrameSize)
                
            } else if isDownloading {
                // 画像のダウンロード中にインジケータを表示
                ProgressView()
                    .frame(width: FrameSize, height: FrameSize)
                
            } else {
                //プレースホルダー
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: FrameSize, height: FrameSize)
                    .onAppear {
                        Task {
                            await downloadProfileImage(userid: userid)
                        }
                    }
            }
        }
    }

    func downloadProfileImage(userid: String) async {
        isDownloading = true
        do {
            let data = try await supabaseService.downloadProfileImage(userid: userid)
            if let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.uploadedImage = image
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "データを画像に変換できませんでした。"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "プロフィール画像のダウンロードに失敗しました: \(error.localizedDescription)"
            }
        }
        DispatchQueue.main.async {
            self.isDownloading = false
        }
    }
}
