//
//  SpaceXTests.swift
//  SpaceXTests
//
//  Created by Paolo Boschini on 2019-04-30.
//  Copyright © 2019 Paolo Boschini. All rights reserved.
//

import XCTest
@testable import SpaceX

class SpaceXTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateFormat() {
        let launch = Launch(missionName: nil, launchDate: "2020-09-01T00:00:00.000Z", rocket: nil, launchSuccess: nil, flightNumber: nil, details: nil, links: nil)
        XCTAssertEqual(launch.formattedLaunchDate, "1 September 2020")
    }
    
    func testVideoFormat() {
        let launch1 = Launch(missionName: nil, launchDate: nil, rocket: nil, launchSuccess: nil, flightNumber: nil, details: nil, links: Links(videoLink: "https://www.youtube.com/watch?v=Apw3xqwsG1U"))
        XCTAssertEqual(launch1.formattedVideo, "https://www.youtube.com/embed/Apw3xqwsG1U")

        let launch2 = Launch(missionName: nil, launchDate: nil, rocket: nil, launchSuccess: nil, flightNumber: nil, details: nil, links: Links(videoLink: "https://youtu.be/AfbIMknNWks"))
        XCTAssertEqual(launch2.formattedVideo, "https://www.youtube.com/embed/AfbIMknNWks")
    }
    
    func testSpaceXConnection() {
        let url = URL(string: String(format: SPACE_X_API, 20, 0))!
        let exp = expectation(description: "GET \(url)")
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")
            exp.fulfill()
        }
        task.resume()
        waitForExpectations(timeout: task.originalRequest!.timeoutInterval) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
            task.cancel()
        }
    }
}
