//
//  RegisterView.swift
//  WomanProtection
//
//  Created by Gözde Civcik on 26.12.2024.
//


import SwiftUI

struct RegisterView: View {
    @EnvironmentObject var appState: AppState
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            Text("Kayıt Ol")
                .font(.largeTitle)
                .padding()

            TextField("Adınız", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("E-posta", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .keyboardType(.emailAddress)

            SecureField("Şifre", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                register()
            }) {
                Text("Kayıt Ol")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .disabled(name.isEmpty || email.isEmpty || password.isEmpty)
        }
        .padding()
    }

    func register() {
        // Kayıt işlemleri
        appState.isRegistered = true
        appState.isLoggedIn = true // Otomatik giriş yap
        print("Kayıt tamamlandı: \(name), \(email)")
    }
}
