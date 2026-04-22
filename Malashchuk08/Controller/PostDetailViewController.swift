////
////  PostDetailViewController.swift
////  Malashchuk08
////
////  Created by Ivanna Malashchuk on 15.04.2026.
////
//
//
//import UIKit
//
//class PostDetailViewController: UIViewController {
//    let post: Post
//
//    init(post: Post) {
//        self.post = post
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        title = "Details"
//        setupUI()
//    }
//
//    private func setupUI() {
//        let scrollView = UIScrollView()
//        let stack = UIStackView()
//        let titleLabel = UILabel()
//        let authorLabel = UILabel()
//        let textLabel = UILabel()
//        let commentsLabel = UILabel()
//
//        scrollView.translatesAutoresizingMaskIntoConstraints = false
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.axis = .vertical
//        stack.spacing = 12
//
//        titleLabel.font = .boldSystemFont(ofSize: 24)
//        titleLabel.numberOfLines = 0
//        titleLabel.text = post.title
//        authorLabel.font = .systemFont(ofSize: 14)
//        authorLabel.textColor = .secondaryLabel
//        authorLabel.text = "@\(post.username)"
//        textLabel.font = .systemFont(ofSize: 17)
//        textLabel.numberOfLines = 0
//        textLabel.text = post.text
//
//        let postImageView = UIImageView()
//        postImageView.translatesAutoresizingMaskIntoConstraints = false
//        postImageView.contentMode = .scaleAspectFit
//        postImageView.clipsToBounds = true
//        postImageView.layer.cornerRadius = 12
//        postImageView.backgroundColor = .tertiarySystemFill
//        NSLayoutConstraint.activate([
//            postImageView.heightAnchor.constraint(equalToConstant: 220)
//        ])
//        
//        commentsLabel.font = .systemFont(ofSize: 15)
//        commentsLabel.numberOfLines = 0
//        commentsLabel.text = post.comments.isEmpty
//            ? "No comments yet..."
//            : post.comments.map { "@\($0.username): \($0.text)" }.joined(separator: "\n\n")
//
//        view.addSubview(scrollView)
//        scrollView.addSubview(stack)
//        [titleLabel, authorLabel, postImageView, textLabel, commentsLabel].forEach { stack.addArrangedSubview($0) }
//        
//        if let urlString = post.image_url,
//           let url = URL(string: urlString) {
//            URLSession.shared.dataTask(with: url) { data, _, _ in
//                guard let data = data,
//                      let image = UIImage(data: data) else { return }
//
//                DispatchQueue.main.async {
//                    postImageView.image = image
//                }
//            }.resume()
//        } else {
//            postImageView.isHidden = true
//        }
//        NSLayoutConstraint.activate([
//            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
//
//            stack.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
//            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
//            stack.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16)
//        ])
//    }
//}

import UIKit

class PostDetailViewController: UIViewController {

    var post: Post?
    var onBookmarkChanged: (() -> Void)?
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var bookmarkButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Details"
        view.backgroundColor = .systemBackground
        setupUI()
    }

    private func setupUI() {
        guard let post = post else { return }

        titleLabel.text = post.title
        titleLabel.numberOfLines = 0

        authorLabel.text = "@\(post.username)"
        domainLabel.text = post.domain
        timeLabel.text = formattedDate(from: post.created_at)
        postTextLabel.text = post.text
        postTextLabel.numberOfLines = 0

        bookmarkButton.setImage(
            UIImage(systemName: post.isSaved ? "bookmark.fill" : "bookmark"),
            for: .normal
        )
        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.layer.cornerRadius = 12

        if let urlString = post.image_url,
           let url = URL(string: urlString) {

            URLSession.shared.dataTask(with: url) { data, _, _ in
                guard let data = data,
                      let image = UIImage(data: data) else { return }

                DispatchQueue.main.async {
                    self.postImageView.image = image
                }
            }.resume()

        } else {
            postImageView.isHidden = true
        }
    }
    
    private func formattedDate(from timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .short
        return formatter.localizedString(for: date, relativeTo: Date())
    }
    @IBAction func bookmarkTapped(_ sender: UIButton) {
        guard let post else { return }

        if post.isSaved {
            LocalPostsStore.shared.removeSavedPost(post)
            self.post?.isSaved = false
        } else {
            LocalPostsStore.shared.addSavedPost(post)
            self.post?.isSaved = true
        }

        bookmarkButton.setImage(
            UIImage(systemName: self.post?.isSaved == true ? "bookmark.fill" : "bookmark"),
            for: .normal
        )

        onBookmarkChanged?()
    }
}
