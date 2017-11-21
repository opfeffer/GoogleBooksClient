import Foundation
import PlaygroundSupport

/// Collection of playground helper methods
public struct Support {

    /// Synchronously retrieves the Google API key from disk. Avoids having to commit access keys to your version control system.
    ///
    /// By default, this function looks to load `~/Documents/Shared Playground Data/google-books-key.txt`.
    ///
    /// - Parameters:
    ///   - filename: name of the file (defaults to `google-books-key.txt`)
    ///   - directoryURL: URL of the directory the file is placed in (defaults to `PlaygroundSupport.playgroundSharedDataDirectory`)
    /// - Returns: The API Key
    /// - Throws: `Foundation.CocoaError`
    static public func getApiKey(filename: String = "google-books-key.txt", directoryURL: URL = playgroundSharedDataDirectory) throws -> String {
        let url = directoryURL.appendingPathComponent(filename)

        return try String(contentsOf: url)
    }
}
