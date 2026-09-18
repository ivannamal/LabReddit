# LabReddit

A Reddit-style feed app for iOS, built as a mixed SwiftUI and UIKit project: SwiftUI owns
the app shell and two of the tabs, while the feed and saved-posts screens are UIKit view
controllers embedded through `UIViewControllerRepresentable`.

## Features

- **Feed** - paginated list of posts loaded from a REST API with `async/await` and
  `URLSession`, using cursor-based paging (`limit` / `after`) and infinite scroll
- **Bookmarking by double tap** - double-tapping a post image saves it, with a custom
  bookmark shape drawn in `UIBezierPath` on a `CAShapeLayer` and animated over the image
- **Saved tab** - bookmarked and locally created posts, persisted as JSON in
  `UserDefaults` and restored on launch
- **Create post** - a SwiftUI form that adds a post to the local list, authored under the
  nickname set in Settings
- **Settings** - nickname stored with `@AppStorage`
- **Sharing** - posts can be shared through `UIActivityViewController`
- **Detail screen** - full post text, author, date and comments

## Architecture

```
Model/        Post, Comment, PostsResponse - Codable models with a custom decoder
              that tolerates missing local-only fields
Service/      NetworkService - async API client with cursor pagination
Storage/      LocalPostsStore - JSON encoding of saved and created posts to UserDefaults
Controller/   PostsViewController, SavedPostsViewController, PostDetailViewController,
              UIKitPostsContainer (the SwiftUI to UIKit bridge)
View/         PostTableViewCell, LocalPostTableViewCell, BookmarkOverlayView
View/SwiftUI/ RootTabView, CreatePostView, LocalPostCardView, SettingsView
```

## Built with

Swift, SwiftUI, UIKit, async/await, URLSession, Codable, UserDefaults, Core Animation.

## Running it

The app expects a local posts API at `http://127.0.0.1:8080/posts`, returning a JSON
object with a list of posts and an `after` cursor. Without that server running the feed
stays empty; the Create, Saved and Settings tabs still work, since they read from local
storage.
