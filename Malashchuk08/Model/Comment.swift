//
//  Comment.swift
//  Malashchuk08
//represents a comment under a post. contains text, author, and identifiers
//  Created by Ivanna Malashchuk on 12.04.2026.
//

import Foundation

struct Comment: Codable, Hashable {
    let username: String
    let text: String
    let id: String
    let post_id: String
    let downs: Int
    let ups: Int
}
