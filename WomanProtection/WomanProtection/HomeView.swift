import SwiftUI
import AVFoundation

struct HomeView: View {
    @State private var isRecording = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var showEmergencyContacts = false
    @State private var showEmergencyCenters = false
    @State private var showAIChatView = false
    @State private var showFeedbackView = false
    @State private var showProfileView = false
    @State private var isFakeCallActive = false
    @State private var player: AVAudioPlayer?

    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                // Acil Durum Butonu
                Button(action: {
                    handleEmergencyCall()
                }) {
                    Image(systemName: isRecording ? "mic.circle.fill" : "phone.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .padding()
                        .foregroundColor(isRecording ? .red : .blue)
                }
                
                Text(isRecording ? "Ses Kaydediliyor..." : "Acil Durum Çağrısı")
                    .font(.headline)
                    .foregroundColor(isRecording ? .red : .blue)
                
                Spacer()
                
                // Alt Buton Barı
                HStack(spacing: 20) {
                    featureButton(
                        image: "person.crop.circle",
                        title: "Kişiler"
                    ) {
                        showEmergencyContacts = true
                    }
                    .sheet(isPresented: $showEmergencyContacts) {
                        EmergencyContactsView()
                    }
                    
                    featureButton(
                        image: "mappin.and.ellipse",
                        title: "Merkezler"
                    ) {
                        showEmergencyCenters = true
                    }
                    .sheet(isPresented: $showEmergencyCenters) {
                        EmergencyCentersView()
                    }
                    
                    featureButton(
                        image: "phone.fill.arrow.up.right",
                        title: "Yalancı Arama"
                    ) {
                        startFakeCall()
                    }
                    
                    featureButton(
                        image: "message.fill",
                        title: "AI ile Sohbet"
                    ) {
                        showAIChatView = true
                    }
                    .sheet(isPresented: $showAIChatView) {
                        AIChatView()
                    }
                    
                    featureButton(
                        image: "square.and.pencil",
                        title: "Geri Bildirim"
                    ) {
                        showFeedbackView = true
                    }
                    .sheet(isPresented: $showFeedbackView) {
                        FeedbackView()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                
                // Yalancı Aramayı Durdur Butonu
                if isFakeCallActive {
                    Button(action: {
                        stopFakeCall()
                    }) {
                        Text("Yalancı Aramayı Durdur")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding()
                }
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.all)
            .navigationBarItems(trailing: settingsButton) // Sağ üstteki ayarlar butonu
        }
    }
    
    // Ayarlar Butonu
    var settingsButton: some View {
        Menu {
            Button(action: {
                showProfileView = true
            }) {
                Label("Profil", systemImage: "person.crop.circle")
            }
            Button(action: {
                shareAudioFile()
            }) {
                Label("Kaydı Paylaş", systemImage: "square.and.arrow.up")
            }
            Button(action: {
                logout()
            }) {
                Label("Çıkış", systemImage: "arrow.backward.circle")
            }
        } label: {
            Image(systemName: "gearshape.fill")
                .font(.title3)
                .foregroundColor(.primary)
        }
        .sheet(isPresented: $showProfileView) {
            ProfileView()
        }
    }
    
    // Çıkış İşlevi
    func logout() {
        print("Kullanıcı çıkış yaptı.")
    }
    
    // Acil Durum Çağrısı ve Ses Kaydı
    func handleEmergencyCall() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    // Ses Kaydını Başlatma
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default)
            try audioSession.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let audioFilePath = documentPath.appendingPathComponent("Kanıtlar/EmergencyRecording.m4a")
            
            try FileManager.default.createDirectory(at: documentPath.appendingPathComponent("Kanıtlar"), withIntermediateDirectories: true)
            
            audioRecorder = try AVAudioRecorder(url: audioFilePath, settings: settings)
            audioRecorder?.record()
            isRecording = true
            print("Kayıt başladı: \(audioFilePath)")
        } catch {
            print("Kayıt başlatılamadı: \(error.localizedDescription)")
        }
    }
    
    // Ses Kaydını Durdurma
    func stopRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        isRecording = false
        print("Kayıt durduruldu.")
    }
    
    // Fake Çağrı İşlevi
    func startFakeCall() {
        guard let soundURL = Bundle.main.url(forResource: "ringtonemp3", withExtension: "wav") else {
            print("Zil sesi bulunamadı.")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: soundURL)
            player?.numberOfLoops = -1 // Sonsuz döngü
            player?.play()
            isFakeCallActive = true
            print("Yalancı arama başladı.")
        } catch {
            print("Zil sesi çalınamadı: \(error.localizedDescription)")
        }
    }
    
    func stopFakeCall() {
        player?.stop()
        isFakeCallActive = false
        print("Yalancı arama durduruldu.")
    }
    
    // Ses Dosyasını Paylaşma
    func shareAudioFile() {
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFilePath = documentPath.appendingPathComponent("Kanıtlar/EmergencyRecording.m4a")
        
        let activityViewController = UIActivityViewController(activityItems: [audioFilePath], applicationActivities: nil)
        UIApplication.shared.windows.first?.rootViewController?.present(activityViewController, animated: true, completion: nil)
    }
    
    // Özellik Butonları için Reusable Component
    func featureButton(image: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Image(systemName: image)
                    .font(.system(size: 24))
                    .foregroundColor(.primary)
                Text(title)
                    .font(.footnote)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
