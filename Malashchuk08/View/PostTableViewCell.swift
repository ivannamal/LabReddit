//
//  PostTableViewCell.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 15.04.2026.
//
import UIKit

class PostTableViewCell: UITableViewCell {
    static let reuseID = "PostTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userlabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var domainLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var bookmarkButton: UIButton!
    @IBOutlet weak var imageContainer: UIView!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!

    private var currentImageURL: String?
    
    private let bookmarkOverlay = BookmarkOverlayView()
    
    var onShare: (() -> Void)?
    var onSave: (() -> Void)?
    var onDoubleTapImage: (() -> Void)?
    var onOpenDetails: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()

        selectionStyle = .none

        imageContainer.layer.cornerRadius = 12
        imageContainer.clipsToBounds = true
        imageContainer.backgroundColor = .tertiarySystemFill

        postImageView.contentMode = .scaleAspectFill
        postImageView.clipsToBounds = true
        postImageView.isUserInteractionEnabled = false

        imageContainer.isUserInteractionEnabled = true

        let singleTap = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap))
        singleTap.numberOfTapsRequired = 1

        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2

        singleTap.require(toFail: doubleTap)

        imageContainer.addGestureRecognizer(singleTap)
        imageContainer.addGestureRecognizer(doubleTap)


        bookmarkOverlay.translatesAutoresizingMaskIntoConstraints = false
        bookmarkOverlay.isUserInteractionEnabled = false
        imageContainer.addSubview(bookmarkOverlay)

        NSLayoutConstraint.activate([
            bookmarkOverlay.topAnchor.constraint(equalTo: imageContainer.topAnchor),
            bookmarkOverlay.leadingAnchor.constraint(equalTo: imageContainer.leadingAnchor),
            bookmarkOverlay.trailingAnchor.constraint(equalTo: imageContainer.trailingAnchor),
            bookmarkOverlay.bottomAnchor.constraint(equalTo: imageContainer.bottomAnchor)
        ])
    }

//    override func prepareForReuse() {
//        super.prepareForReuse()
//        postImageView.image = nil
//        currentImageURL = nil
//    }


    func configure(with post: Post) {
        titleLabel.text = post.title
        userlabel.text = post.username
        domainLabel.text = post.domain
        timeAgoLabel.text = timeAgoString(from: post.created_at)
        likesButton.setTitle("\(post.ups - post.downs)", for: .normal)
        commentsButton.setTitle("\(post.comments.count)", for: .normal)
        postImageView.image = nil
        currentImageURL = post.image_url

        guard let imageURLString = post.image_url,
              let url = URL(string: imageURLString) else {
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, _, _ in
            guard let self = self,
                  let data = data,
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                if self.currentImageURL == imageURLString {
                    self.postImageView.image = image
                }
            }
        }.resume()
    }

    func playBookmarkAnimation() {
        bookmarkOverlay.play()
    }
    
    private func timeAgoString(from timestamp: Double) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let interval = Int(Date().timeIntervalSince(date))

        if interval < 60 {
            return "\(interval)s"
        } else if interval < 3600 {
            return "\(interval / 60)m"
        } else if interval < 86400 {
            return "\(interval / 3600)h"
        } else {
            return "\(interval / 86400)d"
        }
    }

    @IBAction func shareTapped(_ sender: UIButton) {
        onShare?()
    }

    @IBAction func bookmarkTapped(_ sender: UIButton) {
        onSave?()
    }

    @objc private func handleSingleTap() {
        onOpenDetails?()
    }

    @objc private func handleDoubleTap() {
        onDoubleTapImage?()
    }
}
