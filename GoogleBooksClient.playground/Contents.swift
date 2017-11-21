import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import GoogleBooksClient
import Moya
import Result

// Place your api key here: `~/Documents/Shared Playground Data/google-books-key.txt`
let key = try! Support.getApiKey()
let client = GoogleBooksClient(apiKey: .explicit(key), plugins: [NetworkLoggerPlugin()])

//: Volumes

//provider.search(query: "Moby Dick", printTypes: .books) { (result) in
//    defer { PlaygroundPage.current.finishExecution() }
//    guard case Result.success(let list) = result else { return }
//
//    list.items.forEach { print($0.id) }
//}

client.info(volumeId: "2DotAQAAMAAJ") {
    defer { PlaygroundPage.current.finishExecution() }
    guard case Result.success(let volume) = $0 else { return }

    print(volume.info)
}

