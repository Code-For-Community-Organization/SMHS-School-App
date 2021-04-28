//
//  SMHS_ScheduleTests.swift
//  SMHS ScheduleTests
//
//  Created by Jevon Mao on 3/15/21.
//

import XCTest
import SwiftUI
@testable import SMHSSchedule__iOS_

class SMHS_ScheduleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testArrayLastExtension() { 
        var intArray = [1,2,3,0]
        var stringArray = ["a", "c", "b"]
        XCTAssertEqual(intArray.last, 0)
        XCTAssertEqual(stringArray.last, "b")
        intArray.last = 3
        stringArray.last = "J"
        XCTAssertEqual(intArray.last, 3)
        XCTAssertEqual(stringArray.last, "J")
    }
    
    func testUIKitColorExtension() {
        XCTAssertEqual(Color.platformBackground, Color(UIColor.systemBackground))
        XCTAssertEqual(Color.platformLabel , Color(UIColor.label))
        XCTAssertEqual(Color.platformSecondaryBackground, Color(UIColor.secondarySystemBackground))
    }
    
    func testHexStringToColor() {
        let blueColor = hexStringToColor(hex: "#3498db")
        let redColor = hexStringToColor(hex: "e74c3c")
        let testBlueColor = Color(.sRGB, red: 52 / 255, green: 152 / 255, blue: 219 / 255, opacity: 1)
        let testRedColor = Color(.sRGB, red: 231 / 255, green: 76 / 255, blue: 60 / 255, opacity: 1)
        XCTAssertEqual(redColor, testRedColor)
        XCTAssertEqual(blueColor, testBlueColor)
    }
    
    func testStringLinesExtension() {
        let testString = "SMHS Schedule\nis the best app\n"
        XCTAssertEqual(testString.lines[0], "SMHS Schedule")
        XCTAssertEqual(testString.lines[1], "is the best app")
        let testString2 = ""
        XCTAssertEqual(testString2.lines.isEmpty, true)
        let testString3 = "1\n8\n0\n7"
        XCTAssertEqual(testString3.lines[0], "1")
        XCTAssertEqual(testString3.lines[2], "0")
        XCTAssertEqual(testString3.lines[3], "7")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
