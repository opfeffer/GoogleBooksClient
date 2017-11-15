import Foundation
import Moya

internal enum GoogleBooksAPI {

    case search(query: String, projection: Projection, printTypes: PrintTypes, sorting: Sorting, startIndex: Int, maxResults: Int) // swiftlint:disable:this line_length

    case volumeInfo(id: String)
}

extension GoogleBooksAPI: TargetType {

    public var baseURL: URL {
        return URL(string: "https://www.googleapis.com/books/v1/")!
    }

    public var path: String {
        switch self {
        case .search:
            return "volumes"
        case .volumeInfo(let id):
            return "volumes/\(id)"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var sampleData: Data {
        fatalError("currently not supported.")
    }

    public var task: Task {
        if let params = parameters {
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        }

        return .requestPlain
    }

    public var headers: [String: String]? {
        return nil
    }

    public var parameters: [String: Any]? {
        switch self {
        case .search(let params):
            return [
                "q": params.query,
                "projection": params.projection.rawValue,
                "printType": params.printTypes.rawValue,
                "orderBy": params.sorting.rawValue,
                "startIndex": params.startIndex,
                "maxResults": params.maxResults
            ]

        case .volumeInfo:
            return nil
        }
    }
}
