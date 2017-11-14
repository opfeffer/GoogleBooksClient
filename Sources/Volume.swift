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
//        public let printType: PrintType

        public let imageURLs: ImageURLs
        public let infoURL: URL
        public let previewURL: URL

        enum CodingKeys: String, CodingKey {
            case title
            case authors
            case description
//            case printType
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

public struct VolumeList: Decodable {
    public let kind: String
    public let totalItems: Int

    public let items: [Volume]
}
