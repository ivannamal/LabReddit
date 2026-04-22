//
//  PostsResponse.swift
//  Malashchuk08
//represents the server response when fetching posts. contains an array of posts and a pagination cursor (after)
//  Created by Ivanna Malashchuk on 12.04.2026.
//


import Foundation

struct PostsResponse: Codable {
    let posts: [Post]
    let after: String?
}
