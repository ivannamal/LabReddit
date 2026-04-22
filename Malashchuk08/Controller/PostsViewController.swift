//
//  PostsViewController.swift
//  Malashchuk08
//
//  Created by Ivanna Malashchuk on 15.04.2026.
//

import UIKit

class PostsViewController: UITableViewController {

    private var serverPosts: [Post] = []
    private var localPosts: [Post] = []

    private var allPosts: [Post] {
        localPosts + serverPosts
    }

    private var after: String?
    private var isLoading = false

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        title = "Posts"
        view.backgroundColor = .systemBackground

        setupTableView()
        loadLocalPosts()

        Task {
            await fetchPosts()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadLocalPosts()
        updateSavedFlags()
        tableView.reloadData()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        tableView.register(
            LocalPostTableViewCell.self,
            forCellReuseIdentifier: LocalPostTableViewCell.reuseID
        )
    }

    private func loadLocalPosts() {
        localPosts = LocalPostsStore.shared.loadCreatedPosts().reversed()
    }

    private func updateSavedFlags() {
        let savedIDs = Set(LocalPostsStore.shared.loadBookmarkedPosts().map { $0.id })

        localPosts = localPosts.map {
            var post = $0
            post.isLocal = true
            post.isSaved = true
            return post
        }

        serverPosts = serverPosts.map {
            var post = $0
            post.isLocal = false
            post.isSaved = savedIDs.contains(post.id)
            return post
        }
    }

    @MainActor
    private func fetchPosts() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let response = try await NetworkService.shared.fetchPosts(limit: 10, after: after)

            let existingIDs = Set(serverPosts.map { $0.id })
            let savedIDs = Set(LocalPostsStore.shared.loadBookmarkedPosts().map { $0.id })

            let newPosts = response.posts
                .filter { !existingIDs.contains($0.id) }
                .map {
                    var post = $0
                    post.isLocal = false
                    post.isSaved = savedIDs.contains(post.id)
                    return post
                }

            serverPosts.append(contentsOf: newPosts)
            after = response.after

            tableView.reloadData()
        } catch {
            print("Fetch error: \(error)")
        }
    }

    private func share(post: Post) {
        let text = "\(post.title)\n\n\(post.text)"
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        present(vc, animated: true)
    }

    private func save(post: Post, indexPath: IndexPath?) {
        if post.isSaved {
            LocalPostsStore.shared.removeSavedPost(post)
        } else {
            LocalPostsStore.shared.addSavedPost(post)

            if let indexPath,
               let cell = tableView.cellForRow(at: indexPath) as? PostTableViewCell {
                cell.playBookmarkAnimation()
            }
        }

        updateSavedFlags()
        tableView.reloadData()
    }
}

extension PostsViewController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        allPosts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = allPosts[indexPath.row]

        if post.isLocal {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: LocalPostTableViewCell.reuseID,
                for: indexPath
            ) as! LocalPostTableViewCell

            cell.configure(with: post, parent: self)
            return cell
        }

        let cell = tableView.dequeueReusableCell(
            withIdentifier: PostTableViewCell.reuseID,
            for: indexPath
        ) as! PostTableViewCell

        cell.configure(with: post)

        cell.onShare = { [weak self] in
            self?.share(post: post)
        }

        cell.onSave = { [weak self] in
            self?.save(post: post, indexPath: indexPath)
        }

        cell.onDoubleTapImage = { [weak self] in
            self?.save(post: post, indexPath: indexPath)
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
//        let post = allPosts[indexPath.row]
//        let vc = PostDetailViewController(post: post)
//        navigationController?.pushViewController(vc, animated: true)
//    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - scrollView.frame.size.height - 150 {
            Task {
                await fetchPosts()
            }
        }
    }
}
