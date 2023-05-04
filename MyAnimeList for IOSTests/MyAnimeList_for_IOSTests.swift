//
//  MyAnimeList_for_IOSTests.swift
//  MyAnimeList for IOSTests
//
//  Created by Haydar Bahr on 20/04/2023.
//

import XCTest
@testable import MyAnimeList_for_IOS

class HTTPClientControllerTests: XCTestCase {
    var httpClientController: HTTPClientController!

    override func setUp() {
        super.setUp()
        httpClientController = HTTPClientController.shared
    }

    override func tearDown() {
        httpClientController = nil
        super.tearDown()
    }
    func testSearch() {
        let expectation = XCTestExpectation(description: "Search anime")

        httpClientController.query = "Naruto"
        httpClientController.search()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertGreaterThan(self.httpClientController.results.count, 0)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }
    func testGetTrendingAnime() async throws {
        let expectation = XCTestExpectation(description: "Get trending anime")

        do {
            try await httpClientController.getTrendingAnime()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssertGreaterThan(self.httpClientController.topAnime.count, 0)
                expectation.fulfill()
            }
        } catch {
            XCTFail("Error: \(error)")
        }

        wait(for: [expectation], timeout: 10)
    }
    func testGetUpcomingAnime() async throws {
        let expectation = XCTestExpectation(description: "Get upcoming anime")

        do {
            try await httpClientController.getUpcomingAnime()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssertGreaterThan(self.httpClientController.upcomingAnime.count, 0)
                expectation.fulfill()
            }
        } catch {
            XCTFail("Error: \(error)")
        }

        wait(for: [expectation], timeout: 10)
    }
    func testGetAiringAnime() async throws {
        let expectation = XCTestExpectation(description: "Get airing anime")

        do {
            try await httpClientController.getAiringAnime()
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssertGreaterThan(self.httpClientController.airingAnime.count, 0)
                expectation.fulfill()
            }
        } catch {
            XCTFail("Error: \(error)")
        }

        wait(for: [expectation], timeout: 10)
    }



    
    

    
    
}

