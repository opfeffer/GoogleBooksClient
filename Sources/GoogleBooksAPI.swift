//
//  GoogleBooksAPI.swift
//  GoogleBooksClient
//
//  Created by Oliver Pfeffer on 11/13/17.
//  Copyright © 2017 Astrio, LLC. All rights reserved.
//

import Foundation
import Moya

internal enum GoogleBooksAPI {

    case search(query: String, projection: Projection, printTypes: PrintTypes, sorting: Sorting, startIndex: Int, maxResults: Int) // swiftlint:disable:this line_length
}

extension GoogleBooksAPI: TargetType {

    public var baseURL: URL {
        return URL(string: "https://www.googleapis.com/books/v1/")!
    }

    public var path: String {
        switch self {
        case .search:
            return "volumes"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var sampleData: Data {
        fatalError("currently not supported.")
    }

    public var task: Task {
        switch self {
        case .search(let params):
            return .requestParameters(parameters: [
                "q": params.query,
                "projection": params.projection.rawValue,
                "printType": params.printTypes.rawValue,
                "orderBy": params.sorting.rawValue,
                "startIndex": params.startIndex,
                "maxResults": params.maxResults
                ], encoding: URLEncoding.queryString)
        }
    }

    public var headers: [String: String]? {
        return nil
    }

}
