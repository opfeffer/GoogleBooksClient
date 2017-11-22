#  GoogleBooksClient

![badge-swift] ![badge-carthage] ![badge-platforms] [![badge-build]](https://dashboard.buddybuild.com/apps/5a0caaa971247500015f982a/build/latest)

Simple API wrapper for [Google's Books API](https://developers.google.com/books/) written in Swift.

## Features

So far, GoogleBooksClient supports searching for volumes and fetching information about individual volumes by ID.

Currently unsupported: User-specific information via authenticated requests.

### To-Do List
_(not ordered by priority or severity)_

* [ ] Add unit test coverage
* [ ] Support reactive frameworks supported by Moya (RxSwift, ReactiveSwift)
* [ ] Improve documentation
* [x] Add continuous integration (travis-ci? circleCI? **buddybuild**?)
* [x] Add Cocoapods support
* [x] Add Swift Package Manager support

## Installation

### Dependencies/Requirements

* Xcode 9+
* Swift 4
* iOS 10+
* [Moya](https://github.com/Moya/Moya)

### API key

Get your Google API Key from [Google's Developer Console](https://console.developers.google.com). There's two ways of providing your API key to GoogleBooksClient:

1. Explicitly when instantiating `GoogleBooksClient(apiKey: .explicit("YOUR-API-KEY-HERE")`
2. Implicitly via your `Info.plist` entry called `GoogleBooksClientAPIKey`.

*Note: GoogleBooksClient will work for most requests without API key. However, Google's Terms of Service require the use of an API key and/or access token and failure to provide an API key makes your application subject to more aggressive rate limiting!*

### Cocoapods

```ruby
// Podfile

target "YOURTARGETNAME" do
  use_frameworks!

  pod "GoogleBooksClient", :git => "https://github.com/opfeffer/GoogleBooksClient" # directly referencing Github until GA release
end
```

### Carthage

```
// Cartfile

github "opfeffer/GoogleBooksClient" "master"
```

### Swift Package Manager

```swift
// Package.swift

.package(url: "https://github.com/opfeffer/GoogleBooksClient", .branch("master"))
```

## Usage

See `GoogleBooksClient.playground` for details.

### A note on Playground Support

Xcode Playgrounds are a great way to prototype and test functionality without having to constantly re-run your application. It also allows standalone execution of a library/framework. Please note, should your [API key](#api-key) be application-restricted to iOS applications only, you will want to add `com.apple.dt.playground` as a valid bundle identifier in Google's developer console.

## License

GoogleBooksClient is released under an MIT license. See [LICENSE](LICENSE) for more information.

[badge-swift]: https://img.shields.io/badge/swift%20version-4.0-brightgreen.svg
[badge-carthage]: https://img.shields.io/badge/compatible-carthage%20%7C%20cocoapods%20%7C%20swift%20pm-brightgreen.svg
[badge-platforms]: https://img.shields.io/badge/platforms-iOS-lightgrey.svg
[badge-build]: http://builds.opfeffer.com/projects/5a0caaa971247500015f982a/badge
