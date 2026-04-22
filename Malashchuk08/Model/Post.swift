//
//  Post.swift
//  Malashchuk08
//represents a post in the application. contains main information and flags for local and saved state
//  Created by Ivanna Malashchuk on 12.04.2026.
//
import Foundation

struct Post: Codable, Identifiable, Hashable {
    let id: String
    var text: String
    var ups: Int
    var downs: Int
    var title: String
    var created_at: Double
    var username: String
    var domain: String
    var image_url: String?
    var comments: [Comment]
    var isLocal: Bool
    var isSaved: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case text
        case ups
        case downs
        case title
        case created_at
        case username
        case domain
        case image_url
        case comments
        case isLocal
        case isSaved
    }

    init(
        id: String,
        text: String,
        ups: Int,
        downs: Int,
        title: String,
        created_at: Double,
        username: String,
        domain: String,
        image_url: String?,
        comments: [Comment],
        isLocal: Bool = false,
        isSaved: Bool = false
    ) {
        self.id = id
        self.text = text
        self.ups = ups
        self.downs = downs
        self.title = title
        self.created_at = created_at
        self.username = username
        self.domain = domain
        self.image_url = image_url
        self.comments = comments
        self.isLocal = isLocal
        self.isSaved = isSaved
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(String.self, forKey: .id)
        text = try container.decode(String.self, forKey: .text)
        ups = try container.decode(Int.self, forKey: .ups)
        downs = try container.decode(Int.self, forKey: .downs)
        title = try container.decode(String.self, forKey: .title)
        created_at = try container.decode(Double.self, forKey: .created_at)
        username = try container.decode(String.self, forKey: .username)
        domain = try container.decode(String.self, forKey: .domain)
        image_url = try container.decodeIfPresent(String.self, forKey: .image_url)
        comments = try container.decode([Comment].self, forKey: .comments)
        isLocal = try container.decodeIfPresent(Bool.self, forKey: .isLocal) ?? false
        isSaved = try container.decodeIfPresent(Bool.self, forKey: .isSaved) ?? false
    }
}
