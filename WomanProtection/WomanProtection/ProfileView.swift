//
//  ProfileView.swift
//  WomanProtection
//
//  Created by Gözde Civcik on 22.12.2024.
//


import SwiftUI

struct ProfileView: View {
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var birthday: String = ""
    @State private var bloodType: String = ""
    @State private var address: String = ""
    
    @Environment(\.presentationMode) var presentationMode // Sayfayı kapatmak için
    
    let bloodTypes = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Kişisel Bilgiler")) {
                    TextField("Ad", text: $name)
                    TextField("Soyad", text: $surname)
                    TextField("Doğum Tarihi", text: $birthday)
                    Picker("Kan Grubu", selection: $bloodType) {
                        ForEach(bloodTypes, id: \.self) { type in
                            Text(type)
                        }
                    }
                    TextField("Adres", text: $address)
                }
            }
            .navigationTitle("Profil")
            .navigationBarItems(
                leading: Button("İptal") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Kaydet") {
                    saveData()
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .onAppear(perform: loadData)
        }
    }
    
    // Verileri yükleme
    func loadData() {
        if let userData = UserDefaults.standard.dictionary(forKey: "kullaniciBilgileri") as? [String: String] {
            name = userData["ad"] ?? ""
            surname = userData["soyad"] ?? ""
            birthday = userData["dogumTarihi"] ?? ""
            bloodType = userData["kanGrubu"] ?? ""
            address = userData["adres"] ?? ""
        }
    }
    
    // Verileri kaydetme
    func saveData() {
        let userData: [String: String] = [
            "ad": name,
            "soyad": surname,
            "dogumTarihi": birthday,
            "kanGrubu": bloodType,
            "adres": address
        ]
        UserDefaults.standard.set(userData, forKey: "kullaniciBilgileri")
    }
}
