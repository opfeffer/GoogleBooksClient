import XCTest
import Moya
import Result
@testable import GoogleBooksClient

class GoogleBooksClientTests: XCTestCase {

    var client: GoogleBooksClient!

    override func setUp() {
        super.setUp()

        let provider = MoyaProvider<GoogleBooksAPI>(stubClosure: MoyaProvider.immediatelyStub)
        client = GoogleBooksClient(provider: provider)
    }

    override func tearDown() {
        client = nil

        super.tearDown()
    }

    func testVolumeFetch() {
        let id = "XV8XAAAAYAAJ"

        client.info(volumeId: id) { (result) in
            switch result {
            case .failure:
                XCTFail("not expected to fail.")

            case .success(let volume):
                XCTAssert(volume.id == id, "Volume IDs should match.")
            }
        }
    }
}
