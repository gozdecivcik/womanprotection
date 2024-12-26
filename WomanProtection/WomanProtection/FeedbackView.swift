import SwiftUI
import PhotosUI

struct FeedbackView: View {
    @State private var feedbackText: String = ""
    @State private var locationText: String = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var shareLocation: Bool = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Geri Bildirim")) {
                    TextEditor(text: $feedbackText)
                        .frame(height: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }
                
                Section(header: Text("Konum Bilgisi")) {
                    if shareLocation {
                        Text("Konum paylaşımı açık.")
                            .foregroundColor(.gray)
                    } else {
                        TextField("Konumunuzu manuel olarak yazın", text: $locationText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    
                    Toggle(isOn: $shareLocation) {
                        Text("Konumumu Otomatik Paylaş")
                    }
                }
                
                Section(header: Text("Fotoğraf Ekle")) {
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxHeight: 200)
                            .cornerRadius(10)
                            .padding(.vertical)
                    }
                    
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        Text("Fotoğraf Seç")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
            }
            
            Button(action: {
                submitFeedback()
            }) {
                Text("Gönder")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(feedbackText.isEmpty && locationText.isEmpty && selectedImage == nil)
            .padding()
        }
        .navigationTitle("Geri Bildirim")
        .onChange(of: selectedPhoto) { newValue in
            loadImage(from: newValue)
        }
    }
    
    // Fonksiyon: Geri bildirimi gönder
    func submitFeedback() {
        print("Geri bildirim gönderildi: \(feedbackText)")
        if shareLocation {
            print("Konum otomatik olarak paylaşıldı.")
        } else if !locationText.isEmpty {
            print("Manuel olarak girilen konum: \(locationText)")
        }
        if let image = selectedImage {
            print("Bir fotoğraf eklendi.")
            // Fotoğraf gönderim işlemleri burada yapılabilir
        }
    }
    
    // Fotoğraf yükleme fonksiyonu
    func loadImage(from item: PhotosPickerItem?) {
        guard let item = item else { return }
        
        item.loadTransferable(type: Data.self) { result in
            switch result {
            case .success(let data):
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        selectedImage = image
                    }
                }
            case .failure(let error):
                print("Fotoğraf yüklenirken hata oluştu: \(error.localizedDescription)")
            }
        }
    }
}
