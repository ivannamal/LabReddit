//
//  LocalPostsStore.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 15.04.2026.
//

import Foundation

class LocalPostsStore {
    static let shared = LocalPostsStore()

    let savedPostsKey = "saved_posts_key"
    let createdPostsKey = "created_posts_key"

    func saveBookmarkedPosts(_ posts: [Post]) {
        if let data = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(data, forKey: savedPostsKey)
        }
    }

    func loadBookmarkedPosts() -> [Post] {
        guard let data = UserDefaults.standard.data(forKey: savedPostsKey),
              let posts = try? JSONDecoder().decode([Post].self, from: data) else {
            return []
        }
        return posts
    }

    func saveCreatedPosts(_ posts: [Post]) {
        if let data = try? JSONEncoder().encode(posts) {
            UserDefaults.standard.set(data, forKey: createdPostsKey)
        }
    }

    func loadCreatedPosts() -> [Post] {
        guard let data = UserDefaults.standard.data(forKey: createdPostsKey),
              let posts = try? JSONDecoder().decode([Post].self, from: data) else {
            return []
        }
        return posts
    }

    func addSavedPost(_ post: Post) {
        var savedPosts = loadBookmarkedPosts()

        guard !savedPosts.contains(where: { $0.id == post.id }) else { return }

        var updatedPost = post
        updatedPost.isSaved = true
        savedPosts.insert(updatedPost, at: 0)

        saveBookmarkedPosts(savedPosts)
    }

    func removeSavedPost(_ post: Post) {
        var savedPosts = loadBookmarkedPosts()
        savedPosts.removeAll { $0.id == post.id }
        saveBookmarkedPosts(savedPosts)

        if post.isLocal {
            var createdPosts = loadCreatedPosts()
            createdPosts.removeAll { $0.id == post.id }
            saveCreatedPosts(createdPosts)
        }
    }
}
