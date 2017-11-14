import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import GoogleBooksClient
import Moya
import Result

let provider = GoogleBooksProvider(plugins: [NetworkLoggerPlugin()])

//: Volumes
provider.search(query: "Moby Dick", printTypes: .books) { (result) in
    defer { PlaygroundPage.current.finishExecution() }

    guard case Result.success(let list) = result else { return }

    list.items.forEach { print($0.volumeInfo) }
}
