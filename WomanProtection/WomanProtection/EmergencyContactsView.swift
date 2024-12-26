//
//  EmergencyContactsView.swift
//  WomanProtection
//
//  Created by Gözde Civcik on 18.12.2024.
//

import SwiftUI
import Contacts
import ContactsUI

struct EmergencyContactsView: View {
    @State private var contacts: [EmergencyContact] = []
    @State private var showingContactPicker = false
    @State private var showingManualEntry = false
    
    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(contacts) { contact in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(contact.name)
                                    .font(.headline)
                                Text(contact.phoneNumber)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                
                HStack {
                    // Rehberden kişi ekleme
                    Button(action: {
                        showingContactPicker = true
                    }) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Rehberden Ekle")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .sheet(isPresented: $showingContactPicker) {
                        ContactPickerView { selectedContact in
                            contacts.append(selectedContact)
                        }
                    }
                    
                    // Manuel giriş ile kişi ekleme
                    Button(action: {
                        showingManualEntry = true
                    }) {
                        HStack {
                            Image(systemName: "plus")
                            Text("Manuel Ekle")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                    .sheet(isPresented: $showingManualEntry) {
                        ManualEntryView { newContact in
                            contacts.append(newContact)
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Acil Kişiler")
        }
    }
}
