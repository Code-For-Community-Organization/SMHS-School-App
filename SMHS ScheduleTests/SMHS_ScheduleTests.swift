//
//  SMHS_ScheduleTests.swift
//  SMHS ScheduleTests
//
//  Created by Jevon Mao on 3/15/21.
//

import XCTest
@testable import SMHSSchedule__iOS_

class SMHS_ScheduleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testArrayLastExtension() throws {
        var intArray = [1,2,3,0]
        var stringArray = ["a", "c", "b"]
        XCTAssertEqual(intArray.last, 0)
        XCTAssertEqual(stringArray.last, "b")
        intArray.last = 3
        stringArray.last = "J"
        XCTAssertEqual(intArray.last, 3)
        XCTAssertEqual(stringArray.last, "J")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
