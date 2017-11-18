import Foundation

public enum PrintType: String, Decodable {
    case book       = "BOOK"
    case magazine   = "MAGAZINE"
}

// MARK: -

/// Google Books appears to return varying date formats in its `volumes` response.
/// `PublishDate` attempts to standardize the formats and provide a single view of the data.
public struct PublishDate {
    public let rawValue: String

    public let date: Date

    public let format: Format

    public enum Format {
        case year
        case month
        case day
    }
}

extension PublishDate.Format {

    init(componentCount: Int) {
        switch componentCount {
        case 1:
            self = .year
        case 2:
            self = .month
        default:
            self = .day
        }
    }

    var inputDateFormat: String {
        switch self {
        case .year:
            return "yyyy"
        case .month:
            return "yyyy-MM"
        case .day:
            return "yyyy-MM-dd"
        }
    }

    var outputDateFormat: String? {
        let template: String

        switch self {
        case .year:
            template = "yyyy"
        case .month:
            template = "yyyyMMMM"
        case .day:
            template = "yyyyMMMdd"
        }

        return DateFormatter.dateFormat(fromTemplate: template, options: 0, locale: Locale.current)
    }
}

extension PublishDate: Decodable {

    public static let dateFormatter = DateFormatter()

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)

        let format = Format(componentCount: raw.split(separator: "-").count)
        let formatter = type(of: self).dateFormatter
        formatter.dateFormat = format.inputDateFormat

        if let date = formatter.date(from: raw) {
            self.init(rawValue: raw, date: date, format: format)

        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported date format.")
        }
    }
}

public extension PublishDate {

    public static let defaultFormatter = DateFormatter()

    func string(using formatter: DateFormatter? = nil) -> String {
        let formatter = formatter ?? {
            let f = type(of: self).defaultFormatter
            f.dateFormat = format.outputDateFormat
            return f
            }()

        return formatter.string(from: date)
    }
}

// MARK: -

/// A Volume represents information that Google Books hosts about a book or a magazine.
/// It contains metadata, such as title and author, as well as personalized data,
/// such as whether or not it has been purchased.
public struct Volume: Decodable {

    public let id: String
    public let etag: String

    public let info: Info

    enum CodingKeys: String, CodingKey {
        case id
        case etag
        case info = "volumeInfo"
    }

    public struct Info: Decodable {

        public let title: String
        public let authors: [String]?

        public let description: String?
        public let pageCount: Int?
        public let publisher: String?
        public let publishDate: PublishDate?
        public let iso6391LanguageCode: String?

        public let averageRating: Float?
        public let ratingsCount: Int?

        public let imageURLs: ImageURLs
        public let infoURL: URL?
        public let previewURL: URL?

        enum CodingKeys: String, CodingKey {
            case title
            case authors
            case description
            case pageCount
            case publisher
            case publishDate         = "publishedDate"
            case iso6391LanguageCode = "language"
            case averageRating
            case ratingsCount
            case imageURLs           = "imageLinks"
            case infoURL             = "infoLink"
            case previewURL          = "previewLink"
        }
    }

    public struct ImageURLs: Decodable {
        private let store: [String: URL?]

        public init(from decoder: Decoder) throws {
            store = try decoder.singleValueContainer().decode([String: URL?].self)
        }

        public subscript(size: ImageSize) -> URL? {
            return store[size.rawValue] ?? nil
        }

        public func imageURL(targetSize: ImageSize, matching: Matching = .exact) -> URL? {

            switch matching {
            case .exact:
                return self[targetSize]

            case .best:
                var sizes = ImageSize.orderedDesc
                let index: Int = sizes.index(of: targetSize) ?? 0
                sizes = Array(sizes[index..<sizes.count])

                return sizes.flatMap { store[$0.rawValue] }.first ?? nil
            }
        }

        public enum ImageSize: String {
            case smallThumbnail
            case thumbnail
            case small
            case medium
            case large
            case extraLarge

            static let orderedDesc: [ImageSize] = [.extraLarge, .large, .medium, .small, .thumbnail, smallThumbnail]
        }

        public enum Matching {
            case exact
            case best
        }
    }
}

// MARK: -

public struct VolumesList: Decodable {

    public let items: [Volume]
    public let totalItems: Int
}
