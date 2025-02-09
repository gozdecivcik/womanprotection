import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @State private var enteredName: String = ""
    @State private var enteredPassword: String = ""
    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            Text("Giriş Yap")
                .font(.largeTitle)
                .padding()
            
            TextField("Adınız", text: $enteredName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Parola", text: $enteredPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button(action: {
                login()
            }) {
                Text("Giriş Yap")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            
            if showError {
                Text("Ad veya parola hatalı.")
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .padding()
    }
    
    func login() {
        if let userData = UserDefaults.standard.dictionary(forKey: "kullaniciBilgileri"),
           let savedName = userData["ad"] as? String,
           let savedPassword = userData["parola"] as? String,
           enteredName == savedName && enteredPassword == savedPassword {
            appState.isLoggedIn = true
            print("Giriş yapıldı: \(enteredName)")
        } else {
            showError = true
        }
    }
}
