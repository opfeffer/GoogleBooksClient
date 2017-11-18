import Moya
import Result

/// Pagination parameters; `maxResult` needs to be between 0...40.
public typealias Pagination = (startIndex: Int, maxResults: Int)

public struct GoogleBooksClient {

    let provider: MoyaProvider<GoogleBooksAPI>

    public init(provider: MoyaProvider<GoogleBooksAPI> = .init()) {
        self.provider = provider
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

        return provider.request(target, completion: { (result) in
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
        return provider.request(.volumeInfo(id: volumeId), completion: { (result) in
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
