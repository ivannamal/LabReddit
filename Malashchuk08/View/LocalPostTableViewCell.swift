//
//  LocalPostTableViewCell.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 15.04.2026.
//


import UIKit
import SwiftUI

class LocalPostTableViewCell: UITableViewCell {
    static let reuseID = "LocalPostTableViewCell"
    private var hostingController: UIHostingController<LocalPostCardView>?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        selectionStyle = .none
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with post: Post, parent: UIViewController, onToggleSave: (() -> Void)? = nil) {
        hostingController?.view.removeFromSuperview()
        hostingController?.removeFromParent()

        let rootView = LocalPostCardView(post: post, onToggleSave: onToggleSave)
        let host = UIHostingController(rootView: rootView)

        hostingController = host
        parent.addChild(host)
        host.view.translatesAutoresizingMaskIntoConstraints = false
        host.view.backgroundColor = .clear
        contentView.addSubview(host.view)

        NSLayoutConstraint.activate([
            host.view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            host.view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            host.view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            host.view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])

        host.didMove(toParent: parent)
    }
    
}
