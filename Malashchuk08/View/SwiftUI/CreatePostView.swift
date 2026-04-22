//
//  CreatePostView.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 12.04.2026.
//


import SwiftUI

struct CreatePostView: View {
    @AppStorage("username") private var username = ""
    @State private var title = ""
    @State private var text = ""
    @State private var showAlert = false
    @State private var showEmptyFieldsAlert = false
    @Binding var selectedTab: Int

    var body: some View {
        NavigationView {
            Form {
                Section("New post") {
                    TextField("Title", text: $title)
                    TextField("Text", text: $text, axis: .vertical)
                        .lineLimit(5...10)
                }

                Button("Create") {
                    createPost()
                }
            }
            .navigationTitle("Create")
            .alert("Set username first", isPresented: $showAlert) {
                Button("Go to Settings") {
                    selectedTab = 2
                }
            } message: {
                Text("You need to choose a name before creating a post.")
            }
        }
    }

    private func createPost() {
        guard !username.isEmpty else {
            showAlert = true
            return
        }

        guard !title.isEmpty, !text.isEmpty else { return }

        let post = Post(
            id: UUID().uuidString,
            text: text,
            ups: 0,
            downs: 0,
            title: title,
            created_at: Date().timeIntervalSince1970,
            username: username,
            domain: "r/local",
            image_url: nil,
            comments: [],
            isLocal: true,
            isSaved: true
        )

        var createdPosts = LocalPostsStore.shared.loadCreatedPosts()
        createdPosts.insert(post, at: 0)
        LocalPostsStore.shared.saveCreatedPosts(createdPosts)

        LocalPostsStore.shared.addSavedPost(post)
        title = ""
        text = ""
        selectedTab = 0
    }
}

#Preview {
    CreatePostView(selectedTab: .constant(1))
}
