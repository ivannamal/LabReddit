//
//  UIKitPostsContainer.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 15.04.2026.
//

import SwiftUI
import UIKit

struct UIKitPostsContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UITabBarController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let postsVC = storyboard.instantiateViewController(withIdentifier: "PostsViewController") as! PostsViewController
        let savedVC = storyboard.instantiateViewController(withIdentifier: "SavedPostsViewController") as! SavedPostsViewController

        let postsNav = UINavigationController(rootViewController: postsVC)
        let savedNav = UINavigationController(rootViewController: savedVC)

        postsNav.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "list.bullet"), tag: 0)
        savedNav.tabBarItem = UITabBarItem(title: "Saved", image: UIImage(systemName: "bookmark"), tag: 1)

        let tabBar = UITabBarController()
        tabBar.viewControllers = [postsNav, savedNav]

        return tabBar
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
    }
}
