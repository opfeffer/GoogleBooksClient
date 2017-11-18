import Foundation
import Moya

public enum GoogleBooksAPI {

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

    // swiftlint:disable line_length
    public var sampleData: Data {
        switch self {
        case .volumeInfo:
            return "{\"kind\":\"books#volume\",\"id\":\"XV8XAAAAYAAJ\",\"etag\":\"HHSWnx5IEPs\",\"selfLink\":\"https://www.googleapis.com/books/v1/volumes/XV8XAAAAYAAJ\",\"volumeInfo\":{\"title\":\"Moby Dick\",\"authors\":[\"Herman Melville\"],\"publisher\":\"Norton\",\"publishedDate\":\"1892\",\"description\":\"A literary classic that wasn't recognized for its merits until decades after its publication, Herman Melville's Moby-Dick tells the tale of a whaling ship and its crew, who are carried progressively further out to sea by the fiery Captain Ahab. Obsessed with killing the massive whale, which had previously bitten off Ahab's leg, the seasoned seafarer steers his ship to confront the creature, while the rest of the shipmates, including the young narrator, Ishmael, and the harpoon expert, Queequeg, must contend with their increasingly dire journey. The book invariably lands on any short list of the greatest American novels.\",\"readingModes\":{\"text\":true,\"image\":true},\"pageCount\":664,\"printedPageCount\":576,\"dimensions\":{\"height\":\"21.00 cm\"},\"printType\":\"BOOK\",\"averageRating\":4,\"ratingsCount\":301,\"maturityRating\":\"NOT_MATURE\",\"allowAnonLogging\":false,\"contentVersion\":\"1.1.8.0.full.3\",\"panelizationSummary\":{\"containsEpubBubbles\":false,\"containsImageBubbles\":false},\"imageLinks\":{\"smallThumbnail\":\"http://books.google.com/books/content?id=XV8XAAAAYAAJ&printsec=frontcover&img=1&zoom=5&edge=curl&imgtk=AFLRE70n_NjKnh7DATMrxqWsGNsg0BH_4PmBOQKT7cjp3kn2kWpr2DDdtR450sOGbzdE5MASDhIBWfwJuyhKvHN6dc8-4iy9q7-bmH1UeFliZXOEk0zEPE7pE3EAq7BERUKNgZ48bsXP&source=gbs_api\",\"thumbnail\":\"http://books.google.com/books/content?id=XV8XAAAAYAAJ&printsec=frontcover&img=1&zoom=1&edge=curl&imgtk=AFLRE70RCQQscj24H6cqyn-i9svBQuo-qleziWWLNr3ze7iuSYTVsUBJlYlQskzmJUpuUdgPN2GUaeDH4N3ehUSiSILFGKBIoXObBDh17ewGCtmdWiMH2VkkS3GHPablCGV2mYvNXUlM&source=gbs_api\",\"small\":\"http://books.google.com/books/content?id=XV8XAAAAYAAJ&printsec=frontcover&img=1&zoom=2&edge=curl&imgtk=AFLRE72Nras_1pt82zAavbW2KO0vGFGIn1CK8GXIcM7KDXVoJeKsNWqj5gAoGy_oPnGlhXh_HUyvukDlYMEeZWItiLIWxYgVZicpd4KeyBsZl4Eaj2IrWblUVccSOMaHne1BS1HmKXFR&source=gbs_api\",\"medium\":\"http://books.google.com/books/content?id=XV8XAAAAYAAJ&printsec=frontcover&img=1&zoom=3&edge=curl&imgtk=AFLRE730LUi8856l8UuL3BF7uCox4eBGnvbbkgw6RWCrOX2NRFUvGPVn6FpepEA9nNgdQnS1ey_qgwb83uZ1OAYxxKFp1Fc0WbMAIp9L6w2gxnVwxAxyFHNWC7f08cEqjkMBqtea6Lmm&source=gbs_api\",\"large\":\"http://books.google.com/books/content?id=XV8XAAAAYAAJ&printsec=frontcover&img=1&zoom=4&edge=curl&imgtk=AFLRE70JRG2saHptwZuTI_APr0QShKaSU75Cs33wJrrMnG3vGcXK1tmnJ11bmNMynmdtRrOU8cmTFz9k2iT9JUKlfd4Fsy4ofBNknG4sGrwGDM_EQ6ufFARQGCZZig5LV1iTzw12veFU&source=gbs_api\",\"extraLarge\":\"http://books.google.com/books/content?id=XV8XAAAAYAAJ&printsec=frontcover&img=1&zoom=6&edge=curl&imgtk=AFLRE73rpv7t6n57JUrkRIVlmxWjiTOjapgMXhksM3jwSLxnSVdfXwfcqwmUelyT4k10Ux4SyVNM8A-PjWoLeVtz9gUhd3Xxdr50gyUaNEJtq1W18RW_f4WH7gDr0fsfsD_Z79gpLXVY&source=gbs_api\"},\"language\":\"en\",\"previewLink\":\"http://books.google.com/books?id=XV8XAAAAYAAJ&hl=&source=gbs_api\",\"infoLink\":\"https://play.google.com/store/books/details?id=XV8XAAAAYAAJ&source=gbs_api\",\"canonicalVolumeLink\":\"https://market.android.com/details?id=book-XV8XAAAAYAAJ\"},\"layerInfo\":{\"layers\":[{\"layerId\":\"geo\",\"volumeAnnotationsVersion\":\"15\"}]},\"saleInfo\":{\"country\":\"US\",\"saleability\":\"FREE\",\"isEbook\":true,\"buyLink\":\"https://play.google.com/store/books/details?id=XV8XAAAAYAAJ&rdid=book-XV8XAAAAYAAJ&rdot=1&source=gbs_api\"},\"accessInfo\":{\"country\":\"US\",\"viewability\":\"ALL_PAGES\",\"embeddable\":true,\"publicDomain\":true,\"textToSpeechPermission\":\"ALLOWED\",\"epub\":{\"isAvailable\":true,\"downloadLink\":\"http://books.google.com/books/download/Moby_Dick.epub?id=XV8XAAAAYAAJ&hl=&output=epub&source=gbs_api\"},\"pdf\":{\"isAvailable\":true,\"downloadLink\":\"http://books.google.com/books/download/Moby_Dick.pdf?id=XV8XAAAAYAAJ&hl=&output=pdf&sig=ACfU3U2j7tKT8bbSwXHCttT_eX6HUg70aA&source=gbs_api\"},\"webReaderLink\":\"http://play.google.com/books/reader?id=XV8XAAAAYAAJ&hl=&printsec=frontcover&source=gbs_api\",\"accessViewStatus\":\"FULL_PUBLIC_DOMAIN\",\"quoteSharingAllowed\":false}}".data(using: .utf8)!
        case .search:
            fatalError("not supported for \(self)")
        }
    }
    // swiftlint:enable line_length
}
