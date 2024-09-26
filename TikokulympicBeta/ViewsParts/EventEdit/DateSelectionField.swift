import SwiftUI


struct DateSelectionField: View {
    let title: String
    @Binding var date: Date
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 15))
                .bold()
            
            Spacer()
            
            Custom15MinuteDatePicker(selection: $date)
                .frame(width: 200, height: 35)
        }
    }
    
    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy M/d HH:mm"
        return formatter.string(from: date)
    }
}

struct Custom15MinuteDatePicker: UIViewRepresentable {
    @Binding var selection: Date
    
    func makeUIView(context: Context) -> UIDatePicker {
        let picker = UIDatePicker()
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .compact
        picker.minuteInterval = 15
        picker.addTarget(context.coordinator, action: #selector(Coordinator.dateChanged(_:)), for: .valueChanged)
        return picker
    }
    
    func updateUIView(_ uiView: UIDatePicker, context: Context) {
        uiView.date = selection
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject {
        var parent: Custom15MinuteDatePicker
        
        init(_ parent: Custom15MinuteDatePicker) {
            self.parent = parent
        }
        
        @objc func dateChanged(_ sender: UIDatePicker) {
            parent.selection = sender.date
        }
    }
}


struct DateSelectionField_Previews: PreviewProvider {
    static var previews: some View {
        // プレビュー用にStateで初期日付を作成
        @State var previewDate = Date() // 現在の日付をデフォルトに設定
        
        DateSelectionField(title: "タイトル", date: $previewDate)
    }
}
