//
//  LocalPostCardView.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 15.04.2026.
//

import SwiftUI

struct LocalPostCardView: View {
    var post: Post
    var onToggleSave: (() -> Void)?

    @State var upvoteClicked: Bool = false
    @State var downvoteClicked: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(post.username)
                    .font(.system(size: 14, weight: .semibold))

                Image(systemName: "smallcircle.filled.circle.fill")
                    .resizable()
                    .frame(width: 10, height: 10)

                Text(post.domain)
                    .font(.system(size: 14, weight: .semibold))

                Image(systemName: "smallcircle.filled.circle.fill")
                    .resizable()
                    .frame(width: 10, height: 10)

                Text(timeAgo())
                    .font(.system(size: 14, weight: .semibold))

                Spacer()

                Button(action: {
                    onToggleSave?()
                }) {
                    Image(systemName: "bookmark.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.black)
                }
            }

            Text(post.title)
                .lineLimit(1)
                .font(.system(size: 20, weight: .semibold))

            Text(post.text)
                .lineLimit(2)

            if let urlString = post.image_url,
               let url = URL(string: urlString) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(15)
                } placeholder: {
                    ProgressView()
                }
            }

            HStack {
                Button(action: voteLogic) {
                    Image(systemName: upvoteClicked ? "arrowshape.up.fill" : "arrowshape.up")
                        .font(.system(size: 20))
                    Text(upvoteClicked ? "\(post.ups + 1)" : "\(post.ups)")
                        .padding(-5)
                }
                .foregroundStyle(Color.black)

                Button(action: unvoteLogic) {
                    Image(systemName: downvoteClicked ? "arrowshape.down.fill" : "arrowshape.down")
                        .font(.system(size: 20))
                    Text(downvoteClicked ? "\(post.downs + 1)" : "\(post.downs)")
                        .padding(-5)
                }
                .foregroundStyle(Color.black)

                Spacer()

                HStack {
                    Image(systemName: "bubble.right")
                    Text("\(post.comments.count)")
                }

                Spacer()

                ShareLink(item: "http://127.0.0.1:8080/posts/" + post.id) {
                    Label("", systemImage: "square.and.arrow.up")
                }
                .foregroundStyle(Color.black)
            }
            .padding(.horizontal, 5)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    func voteLogic() {
        if (upvoteClicked && !downvoteClicked) || (!upvoteClicked && downvoteClicked) {
            downvoteClicked = false
        }
        upvoteClicked.toggle()
    }

    func unvoteLogic() {
        if (upvoteClicked && !downvoteClicked) || (!upvoteClicked && downvoteClicked) {
            upvoteClicked = false
        }
        downvoteClicked.toggle()
    }

    func timeAgo() -> String {
        let date = Date(timeIntervalSince1970: post.created_at)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}
