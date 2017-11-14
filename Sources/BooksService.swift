//
//  BooksService.swift
//  GoogleBooksClient
//
//  Created by Oliver Pfeffer on 11/13/17.
//  Copyright © 2017 Astrio, LLC. All rights reserved.
//

import Foundation
import Moya

public enum BooksService {

    static let baseURL: URL = "https://www.googleapis.com/books/v1/"

    case search(query: String)
}

extension BooksService: TargetType {

    public var baseURL: URL {
        return type(of: self).baseURL
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
        return Data()
    }

    public var task: Task {
        switch self {
        case .search(let query):
            return .requestParameters(parameters: ["q": query], encoding: URLEncoding.queryString)
        }
    }

    public var headers: [String : String]? {
        return nil
    }

}
