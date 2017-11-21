import Moya
import Result

/// API Client object. Provides a typed interface to Google's Book API.
public class GoogleBooksClient: MoyaProvider<GoogleBooksAPI> {

    /// Pagination parameters; `maxResult` needs to be between 0...40.
    public typealias Pagination = (startIndex: Int, maxResults: Int)

    /// Initializes a provider.
    ///
    /// - Parameters:
    ///   - apiKey: API key for Google API (defaults to `.infoDictionary`).
    ///   - stubClosure: Moya's mechanism to support request stubbing (defaults to `.neverStub`).
    ///   - plugins: Exposing Moya's plugin architecture.
    public required init(apiKey: APIKeySource = .infoDictionary, stubClosure: @escaping StubClosure = MoyaProvider.neverStub, plugins: [PluginType] = []) {
        var plugins = plugins
        let apiKeyPlugin = APIKeyPlugin(key: apiKey.value)
        plugins.append(apiKeyPlugin)

        super.init(endpointClosure: MoyaProvider.defaultEndpointMapping,
                   requestClosure: MoyaProvider.defaultRequestMapping,
                   stubClosure: stubClosure,
                   callbackQueue: nil,
                   manager: MoyaProvider<Target>.defaultAlamofireManager(),
                   plugins: plugins,
                   trackInflights: false)
    }

    /// Performs a volume search.
    ///
    /// - Parameters:
    ///   - query: Search for volumes that contain this text string
    ///   - projection: Defines what Volume fields to return (defaults to `.lite`)
    ///   - printTypes: Use to restrict the returned results to a specific print/publication type (defaults to `.all`)
    ///   - sorting: Defines sort order (defaults to `.relevance`)
    ///   - pagination: Pagination parameters
    ///   - completion: Closure called on request completion
    /// - Returns: `Cancellable` token to manage request progress.
    @discardableResult
    public func search(query: String, projection: Projection = .lite, printTypes: PrintTypes = .all, sorting: Sorting = .relevance, pagination: Pagination = (0, 10), completion: @escaping (Result<VolumesList, MoyaError>) -> Void) -> Cancellable {
        let target = GoogleBooksAPI.search(query: query,
                                           projection: projection,
                                           printTypes: printTypes,
                                           sorting: sorting,
                                           startIndex: pagination.startIndex,
                                           maxResults: pagination.maxResults)

        return request(target, completion: { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))

            case .success(let response):
                do {
                    let list = try response.map(VolumesList.self)
                    completion(.success(list))

                } catch {
                    let e = MoyaError.objectMapping(error, response)
                    completion(.failure(e))
                }
            }
        })
    }

    /// Retrieves a specific volume by its volume ID
    ///
    /// - Parameters:
    ///   - volumeId: Volume ID
    ///   - completion: Closure called on request completion
    /// - Returns: `Cancellable` token to manage request progess.
    @discardableResult
    public func info(volumeId: String, completion: @escaping (Result<Volume, MoyaError>) -> Void) -> Cancellable {
        return request(.volumeInfo(id: volumeId), completion: { (result) in
            switch result {
            case .failure(let error):
                completion(.failure(error))

            case .success(let response):
                do {
                    let volume = try response.map(Volume.self)
                    completion(.success(volume))
                } catch {
                    let e = MoyaError.objectMapping(error, response)
                    completion(.failure(e))
                }
            }
        })
    }

}

// MARK: -

public extension GoogleBooksClient {

    enum APIKeySource {

        case explicit(String)

        case infoDictionary
    }

}

extension GoogleBooksClient.APIKeySource {

    var value: String {
        switch self {

        case .explicit(let key):
            return key

        case .infoDictionary:
            let key = Bundle.main.infoDictionary?["GoogleBooksClientAPIKey"] as? String
            assert(key != nil, "Please specify a Google API key in your Info.plist (key=`GoogleBooksClientAPIKey`).")

            return key ?? ""
        }
    }
}

// MARK: -

internal struct APIKeyPlugin: PluginType {
    let key: String

    func prepare(_ request: URLRequest, target: TargetType) -> URLRequest {
        guard let url = request.url,
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            else { return request }

        let queryItem = URLQueryItem(name: "key", value: key)
        let queryItems = components.queryItems ?? []
        components.queryItems = queryItems + [queryItem]

        var request = request
        request.url = components.url ?? request.url

        var identifier = Bundle.main.bundleIdentifier ?? "GoogleBooksClient"

        // Bundle Identifiers for Xcode-generated playground projects include randomly generated
        // Simulator UUIDs, for simplicity, we strip those off
        if identifier.hasPrefix("com.apple.dt.playground") {
            identifier = "com.apple.dt.playground"
        }

        // see:
        // https://github.com/GoogleCloudPlatform/cloud-vision/issues/16
        // https://groups.google.com/forum/#!topic/google-cloud-endpoints/I-u3sAUU3Ts
        request.addValue(identifier, forHTTPHeaderField: "X-Ios-Bundle-Identifier")

        return request
    }
}
