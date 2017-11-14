//
//  Volume.swift
//  GoogleBooksClient
//
//  Created by Oliver Pfeffer on 11/13/17.
//  Copyright © 2017 Astrio, LLC. All rights reserved.
//

import Foundation

public enum PrintType: String, Decodable {
    case book       = "BOOK"
    case magazine   = "MAGAZINE"
}

/// Google Books appears to return varying date formats in its `volumes` response.
/// `PublishDate` attempts to standardize the formats and provide a single view of the data.
public enum PublishDate {
    case year(Int)
    case date(Date)
}

extension PublishDate: Decodable {

    public static let dateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "YYYY-MM-DD"
        return fmt
    }()

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)

        if let date = type(of: self).dateFormatter.date(from: raw) {
            self = .date(date)

        } else if let year = Int(raw) {
            self = .year(year)

        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported date format.")
        }
    }

}

public extension PublishDate {

    public static let defaultFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        return fmt
    }()

    func string(using formatter: DateFormatter = PublishDate.defaultFormatter) -> String {
        switch self {
        case .year(let year):
            return "\(year)"

        case .date(let date):
            return formatter.string(from: date)

        }
    }
}

/// A Volume represents information that Google Books hosts about a book or a magazine.
/// It contains metadata, such as title and author, as well as personalized data,
/// such as whether or not it has been purchased.
public struct Volume: Decodable {
    public let id: String
    public let etag: String

    public let volumeInfo: VolumeInfo

    public struct VolumeInfo: Decodable {

        public let title: String
        public let authors: [String]

        public let description: String
        public let publishDate: PublishDate

        public let imageURLs: ImageURLs
        public let infoURL: URL
        public let previewURL: URL

        enum CodingKeys: String, CodingKey {
            case title
            case authors
            case description
            case publishDate    = "publishedDate"
            case imageURLs      = "imageLinks"
            case infoURL        = "infoLink"
            case previewURL     = "previewLink"
        }

    }

    public struct ImageURLs: Decodable {
        public let smallThumbnailURL: URL
        public let thumbnailURL: URL

        enum CodingKeys: String, CodingKey {
            case smallThumbnailURL  = "smallThumbnail"
            case thumbnailURL       = "thumbnail"
        }
    }
}

public struct VolumesList: Decodable {

    public let items: [Volume]
    public let totalItems: Int
}
