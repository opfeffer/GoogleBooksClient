import Foundation

public enum PrintType: String, Decodable {
    case book       = "BOOK"
    case magazine   = "MAGAZINE"
}

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

/// A Volume represents information that Google Books hosts about a book or a magazine.
/// It contains metadata, such as title and author, as well as personalized data,
/// such as whether or not it has been purchased.
public struct Volume: Decodable {
    public let id: String
    public let etag: String

    public let info: VolumeInfo

    enum CodingKeys: String, CodingKey {
        case id
        case etag
        case info = "volumeInfo"
    }

    public struct VolumeInfo: Decodable {

        public let title: String
        public let authors: [String]

        public let description: String
        public let pageCount: Int?
        public let publishDate: PublishDate?

        public let imageURLs: ImageURLs?
        public let infoURL: URL
        public let previewURL: URL

        public init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            title = try container.decode(String.self, forKey: .title)
            authors = try container.decodeIfPresent([String].self, forKey: .authors) ?? []
            description = try container.decodeIfPresent(String.self, forKey: .description) ?? NSLocalizedString("No description available", comment: "")
            pageCount = try container.decodeIfPresent(Int.self, forKey: .pageCount)
            publishDate = try container.decodeIfPresent(PublishDate.self, forKey: .publishDate)
            imageURLs = try container.decodeIfPresent(ImageURLs.self, forKey: .imageURLs)
            infoURL = try container.decode(URL.self, forKey: .infoURL)
            previewURL = try container.decode(URL.self, forKey: .previewURL)
        }

        enum CodingKeys: String, CodingKey {
            case title
            case authors
            case description
            case pageCount
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
