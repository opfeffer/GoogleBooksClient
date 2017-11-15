#  GoogleBooksClient

![badge-swift] ![badge-carthage] ![badge-platforms]

Simple API wrapper for [Google's Books API](https://developers.google.com/books/) written in Swift.

## Features

So far, GoogleBooksClient supports searching for volumes and fetching information about individual volumes by ID.

Currently unsupported: User-specific information via authenticated requests.

### To-Do List
_(not ordered by priority or severity)_

* [x] Add Cocoapods support
* [x] Add Swift Package Manager support
* [ ] Add unit test coverage
* [ ] Support reactive frameworks supported by Moya (RxSwift, ReactiveSwift)
* [ ] Improve documentation
* [ ] Add continuous integration (travis-ci? circleCI? buddybuild?)

## Installation

### Dependencies

* Xcode 9/Swift 4
* [Moya](https://github.com/Moya/Moya)

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

## License

GoogleBooksClient is released under an MIT license. See [LICENSE](LICENSE) for more information.


[badge-swift]: https://img.shields.io/badge/swift%20version-4.0-green.svg
[badge-carthage]: https://img.shields.io/badge/compatible-carthage-brightgreen.svg
[badge-platforms]: https://img.shields.io/badge/platforms-iOS-lightgrey.svg
