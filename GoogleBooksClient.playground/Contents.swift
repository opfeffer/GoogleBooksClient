import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

import GoogleBooksClient
import Moya
import Result

let provider = MoyaProvider<GoogleBooksAPI>(plugins: [NetworkLoggerPlugin()])
let client = GoogleBooksClient(provider: provider)

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

    print(volume.info.imageURLs[.medium])
    print(volume.info.imageURLs.imageURL(targetSize: .medium, matching: .best))
}
