//
//  SettingsView.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 12.04.2026.
//


import SwiftUI

struct SettingsView: View {
    @AppStorage("username") private var username = ""

    var body: some View {
        NavigationView {
            Form {
                Section("Author") {
                    TextField("Nickname", text: $username)
                }
            }
            .navigationTitle("Settings")
        }
    }
}
