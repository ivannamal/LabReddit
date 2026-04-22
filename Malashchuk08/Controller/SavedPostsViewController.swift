//
//  SavedPostsViewController.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 15.04.2026.
//
import UIKit

class SavedPostsViewController: UITableViewController {

    var posts: [Post] = []
    var filteredPosts: [Post] = []
    let searchController = UISearchController(searchResultsController: nil)

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Saved"
        view.backgroundColor = .systemBackground

        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300

        tableView.register(
            LocalPostTableViewCell.self,
            forCellReuseIdentifier: LocalPostTableViewCell.reuseID
        )

        setupSearch()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPosts()
    }

    private func setupSearch() {
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search saved posts"
    }

    private func loadPosts() {
        posts = LocalPostsStore.shared.loadBookmarkedPosts()
        filteredPosts = posts
        tableView.reloadData()
    }

    private func remove(post: Post) {
        LocalPostsStore.shared.removeSavedPost(post)
        loadPosts()
    }

    private func filterPosts(with text: String) {
        if text.isEmpty {
            filteredPosts = posts
        } else {
            let query = text.lowercased()

            filteredPosts = posts.filter {
                $0.title.lowercased().contains(query) ||
                $0.text.lowercased().contains(query) ||
                $0.username.lowercased().contains(query)
            }
        }

        tableView.reloadData()
    }
}

extension SavedPostsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let text = searchController.searchBar.text ?? ""
        filterPosts(with: text)
    }
}

extension SavedPostsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredPosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = filteredPosts[indexPath.row]

        if post.isLocal {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LocalPostTableViewCell.reuseID,
                for: indexPath
            ) as! LocalPostTableViewCell

            cell.configure(with: post, parent: self) { [weak self] in
                self?.remove(post: post)
            }
            return cell
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.reuseID,
            for: indexPath
        ) as! PostTableViewCell

        cell.configure(with: post)

        cell.onShare = { [weak self] in
            guard let self else { return }
            let text = "\(post.title)\n\n\(post.text)"
            let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
            self.present(vc, animated: true)
        }

        cell.onSave = { [weak self] in
            self?.remove(post: post)
        }

        cell.onDoubleTapImage = { [weak self] in
            self?.remove(post: post)
        }

        cell.onOpenDetails = { [weak self] in
            guard let self else { return }

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "PostDetailViewController") as? PostDetailViewController {
                vc.post = post
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

        return cell
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let post = filteredPosts[indexPath.row]
//        let vc = PostDetailViewController(post: post)
//        navigationController?.pushViewController(vc, animated: true)
//    }

//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        guard editingStyle == .delete else { return }
//        let post = filteredPosts[indexPath.row]
//        remove(post: post)
//    }
}
