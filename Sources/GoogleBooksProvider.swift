//
//  GoogleBooksProvider.swift
//  GoogleBooksClient
//
//  Created by Oliver Pfeffer on 11/13/17.
//  Copyright © 2017 Astrio, LLC. All rights reserved.
//

import Moya
import Result

public typealias Pagination = (startIndex: Int, maxResults: Int)

public struct GoogleBooksProvider {

    let provider: MoyaProvider<GoogleBooksAPI>

    public init(plugins: [PluginType] = []) {
        provider = MoyaProvider(plugins: plugins)
    }

    public func search(query: String, projection: Projection = .lite, printTypes: PrintTypes = .all, sorting: Sorting = .relevance, pagination: Pagination = (0, 10), completion: @escaping (Result<VolumeList, MoyaError>) -> Void) -> Cancellable {
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
                    let list = try response.map(VolumeList.self)
                    completion(.success(list))

                } catch {
                    completion(.failure(MoyaError.jsonMapping(response)))
                }
            }

        })
    }

}
