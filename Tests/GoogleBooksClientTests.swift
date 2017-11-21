import XCTest
import Moya
import Result
@testable import GoogleBooksClient

class GoogleBooksClientTests: XCTestCase {

    var client: GoogleBooksClient!

    override func setUp() {
        super.setUp()

        client = GoogleBooksClient(apiKey: .explicit(""), stubClosure: MoyaProvider.immediatelyStub)
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
