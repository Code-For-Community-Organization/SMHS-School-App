//
//  SMHS_ScheduleTests.swift
//  SMHS ScheduleTests
//
//  Created by Jevon Mao on 3/15/21.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import SMHSSchedule__iOS_

struct HighlightButtonStyleTestView: View {
    var body: some View{
        Button(action: {}, label: {
            Text("Button")
        })
        .buttonStyle(HighlightButtonStyle())
    }
}
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
        let emptyArray: [Double] = []
        XCTAssertEqual(intArray.last, 0)
        XCTAssertEqual(stringArray.last, "b")
        intArray.last = 3
        stringArray.last = "J"
        XCTAssertEqual(intArray.last, 3)
        XCTAssertEqual(stringArray.last, "J")
        XCTAssertEqual(emptyArray.last, nil)
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
    
    func testCurrentWeekDayExtension() {
        let currentWeekday = Calendar.current.component(.weekday, from: Date())-1
        XCTAssertEqual(Date.currentWeekday, currentWeekday)
    }
    
    func testGetDayOfTheWeekExtension() {
        let dayOfTheWeek = Calendar.current.component(.weekday, from: Date())-1
        XCTAssertEqual(Date.getDayOfTheWeek(for: Date()), dayOfTheWeek)
    }

    func testParseScheduleData() throws {
        let sampleText = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//Santa Margarita Catholic High School/finalsite//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nX-WR-CALNAME:BELL Schedule\r\nBEGIN:VEVENT\r\nUID:703702@smhsorg.finalsite.com\r\nDTSTAMP:20210421T222201Z\r\nDTSTART;VALUE=DATE:20210322\r\nSUMMARY:SMCHS Events\r\nDESCRIPTION:\\nSpring Recess\\n\\nFaculty/Student Holiday\\n\\nB JV/V Golf @ Ayala Tourn\\n\\nG JV Tennis vs Tesoro 3:00\\n\\nG V Golf vs Aliso Niguel 4:30\\n\\nG V Tennis @ Tesoro 3:00\\n\r\nPRIORITY:0\r\nEND:VEVENT\r\nBEGIN:VEVENT\r\nUID:703695@smhsorg.finalsite.com\r\nDTSTAMP:20210421T222201Z\r\nDTSTART;VALUE=DATE:20210323\r\nSUMMARY:Special Schedule Day 5\r\nDESCRIPTION:Period 5                                   8:00-9:05\\n\\nPeriod 6                                   9:12-10:22 \\n(5 minutes for announcements)\\n\\nNutrition             Period 7 \\n10:22-11:02       10:29-11:34 \\n\\nPeriod 7             Nutrition \\n11:09-12:14      11:34-12:14 \\n\\nPeriod 1                                   12:21-1:26 \\n\\nClass Officer Elections            1:31-2:00 \\n(So/Jr report to Distribution Periods for elections) \\n\\nOffice Hours                            2:05-2:30 \\n------------------------------- \\n\\nClass Officer Elections\\n\\n(So/Jr 8:00-2:00)\\n\\n(Fr/Sr 8:00-1:26)\\n\\nHomecoming Spirit Week\\n\\nB FS/JV/V Soccer @ MD 3:15/7:00/5:00\\n\\nFr/V Baseball @ Dana Hills 3:15/3:15\\n\\nG FS/JV/V Soccer vs MD 3:00/7:15/5:30\\n\\nG JV Tennis @ JSerra 3:00\\n\\nG V Tennis vs JSerra 3:15\\n\\nJV Blue Baseball vs Dana Hills 3:15\\n\\nKairos\\n\\nSball @ San Clemente 3:30\\n\r\nPRIORITY:0\r\nEND:VEVENT\r\nBEGIN:VEVENT\r\nUID:703692@smhsorg.finalsite.com\r\nDTSTAMP:20210421T222201Z\r\nDTSTART;VALUE=DATE:20210324\r\n"
        let expectation = XCTestExpectation(description: "Wait for parsing text")
        var scheduleWeeks: [ScheduleWeek]?
        ScheduleDateHelper().parseScheduleData(withRawText: sampleText){
            scheduleWeeks = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        _ = try XCTUnwrap(scheduleWeeks)
        
    }
    
    func testHighlightButtonStyle() {
        let view = HighlightButtonStyleTestView()
        assertSnapshot(matching: view, as: .image)
    }

    func testTodayView() {
        let todayView = TodayView(scheduleViewViewModel: ScheduleViewModel(currentWeekday: 1))
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
            .environmentObject(UserSettings())
        assertSnapshot(matching: todayView, as: .image)
    }

    func testScheduleView() {
        let view = ScheduleView(scheduleViewModel: ScheduleViewModel.mockScheduleView)
            .environmentObject(UserSettings())
        assertSnapshot(matching: view, as: .image)
    }
    
    func testContentView() {
        let view = ContentView()
        let hostingView = UIHostingController(rootView: view)
        assertSnapshot(matching: view, as: .image)
        assertSnapshot(matching: hostingView, as: .recursiveDescription)
    }
    
    func testNewsView() {
        let view = NewsView(newsViewViewModel: .sampleNewsViewViewModel, scheduleViewModel: .mockScheduleView)
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        let hostingView = UIHostingController(rootView: view)
        assertSnapShot(matching: hostingView, as: .recursiveDescription)
    }
    
    func testOnboardingViewNew() {
        let view = OnboardingView(versionStatus: .new, stayInPresentation: .constant(true))
        assertSnapShot(matching: view, as: .image)
    }
    
    func testOnboardingViewUpdate() {
        let view = OnboardingView(versionStatus: .updated, stayInPresentation: .constant(true))
        assertSnapShot(matching: view, as: .image)
    }
    func testScheduleDetailView() {
        let view = ClassScheduleView(scheduleText: "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n")
            .frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
        assertSnapshot(matching: view, as: .image)
    }
    func testParseClassPeriods() {
        let testScheduleText = "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n"
        let scheduleDay = ScheduleDay(id: 1, date: Date(), scheduleText: testScheduleText)
        let periods = scheduleDay.parseClassPeriods()
        XCTAssertEqual(scheduleDay.periods, periods)
        XCTAssertEqual(periods.first?.periodNumber, 6)
        XCTAssertEqual(periods.first?.startTime, DateFormatter.formatTime12to24("8:00"))
        XCTAssertEqual(periods.first?.endTime, DateFormatter.formatTime12to24("9:05"))
        
        XCTAssertEqual(periods[2].nutritionBlock, .firstLunch)
        XCTAssertEqual(periods[2].startTime, DateFormatter.formatTime12to24("10:22"))
        XCTAssertEqual(periods[2].endTime, DateFormatter.formatTime12to24("11:02"))
        
        XCTAssertEqual(periods[3].nutritionBlock, .secondLunch)
        XCTAssertEqual(periods[3].periodNumber, 1)
        XCTAssertEqual(periods[3].startTime, DateFormatter.formatTime12to24("10:29"))
        XCTAssertEqual(periods[3].endTime, DateFormatter.formatTime12to24("11:34"))
        
        XCTAssertEqual(periods[5].nutritionBlock, .firstLunch)
        XCTAssertEqual(periods[5].periodNumber, 1)
        XCTAssertEqual(periods[5].startTime, DateFormatter.formatTime12to24("11:09"))
        XCTAssertEqual(periods[5].endTime, DateFormatter.formatTime12to24("12:14"))
        
        XCTAssertEqual(periods.last?.periodNumber, 2)
        XCTAssertEqual(periods.last?.startTime, DateFormatter.formatTime12to24("12:21"))
        XCTAssertEqual(periods.last?.endTime, DateFormatter.formatTime12to24("1:26"))
    }
    
    func testIsBetweenExtension() {
        var minDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        var maxDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        XCTAssertEqual(Date().isBetween(minDate, and: maxDate), true)
        minDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        maxDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        XCTAssertEqual(Date().isBetween(minDate, and: maxDate), false)
    }
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
