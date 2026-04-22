//
//  RootTabView.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 15.04.2026.
//


import SwiftUI

struct RootTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            UIKitPostsContainer()
                .tabItem {
                    Label("Browse", systemImage: "square.grid.2x2")
                }
                .tag(0)

            CreatePostView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Create", systemImage: "plus.circle")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
                .tag(2)
        }
    }
}
