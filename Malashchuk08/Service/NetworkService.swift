//
//  NetworkService.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 12.04.2026.
//


import Foundation

class NetworkService {
    static let shared = NetworkService()
    let baseURL = "http://127.0.0.1:8080/posts"

    func fetchPosts(limit: Int = 10, after: String? = nil) async throws -> PostsResponse {
        var components = URLComponents(string: baseURL)!
        var items = [URLQueryItem(name: "limit", value: String(limit))]
        if let after = after, !after.isEmpty {
            items.append(URLQueryItem(name: "after", value: after))
        }
        components.queryItems = items
        guard let url = components.url else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        return try decoder.decode(PostsResponse.self, from: data)
    }
}
