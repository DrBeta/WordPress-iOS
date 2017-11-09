import XCTest
import WebKit
@testable import WordPress

class CookieJarTests: XCTestCase {
    var mockCookieJar = MockCookieJar()
    var cookieJar: CookieJar {
        return mockCookieJar
    }
    let wordPressComLoginURL = URL(string: "https://wordpress.com/wp-login.php")!

    override func setUp() {
        super.setUp()
        mockCookieJar = MockCookieJar()
    }

    func testGetCookies() {
        addCookies()

        let expectation = self.expectation(description: "getCookies completion called")
        cookieJar.getCookies(url: wordPressComLoginURL) { (cookies) in
            XCTAssertEqual(cookies.count, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testHasCookieMatching() {
        addCookies()

        let expectation = self.expectation(description: "hasCookie completion called")
        cookieJar.hasCookie(url: wordPressComLoginURL, username: "testuser") { (matches) in
            XCTAssertTrue(matches)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)

    }
    func testHasCookieNotMatching() {
        addCookies()

        let expectation = self.expectation(description: "hasCookie completion called")
        cookieJar.hasCookie(url: wordPressComLoginURL, username: "anotheruser") { (matches) in
            XCTAssertFalse(matches)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRemoveCookiesMatching() {
        addCookies()

        let expectation = self.expectation(description: "removeCookies completion called")
        cookieJar.removeCookies(url: wordPressComLoginURL, username: "testuser") { [mockCookieJar] in
            XCTAssertEqual(mockCookieJar.cookies?.count, 0)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testRemoveCookiesNotMatching() {
        addCookies()

        let expectation = self.expectation(description: "removeCookies completion called")
        cookieJar.removeCookies(url: wordPressComLoginURL, username: "anotheruser") { [mockCookieJar] in
            XCTAssertEqual(mockCookieJar.cookies?.count, 1)
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1, handler: nil)
    }
}

private extension CookieJarTests {
    func addCookies() {
        mockCookieJar.setWordPressComCookie(username: "testuser")
    }
}
