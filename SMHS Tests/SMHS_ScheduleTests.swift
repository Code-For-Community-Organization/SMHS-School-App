//
//  SMHS_ScheduleTests.swift
//  SMHS ScheduleTests
//
//  Created by Jevon Mao on 3/15/21.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import SMHS

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
        let date = Date()
        let currentWeekday = Calendar.current.component(.weekday, from: date)-1
        XCTAssertEqual(Date.getDayOfTheWeek(for: date), currentWeekday)
    }
    
    func testGetDayOfTheWeekExtension() {
        let date = Date()
        let dayOfTheWeek = Calendar.current.component(.weekday, from: date)-1
        XCTAssertEqual(Date.getDayOfTheWeek(for: date), dayOfTheWeek)
    }

    func getCurrentPeriodHelper(date: String) -> ScheduleDay {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let mockDate = formatter.date(from: date)!
        let scheduleText = "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n"
        let scheduleDay = ScheduleDay(date: mockDate,
                                      scheduleText: scheduleText,
                                      mockDate: mockDate)
        return scheduleDay
    }
    
    func testGetCurrentPeriodRemainingTimeNormal() throws {
        let scheduleDay = getCurrentPeriodHelper(date: "2021/03/01 09:30")
        let remainingTime = try XCTUnwrap(scheduleDay.getCurrentPeriodRemainingTime(selectionMode: .firstLunch))
        
        XCTAssertEqual(remainingTime, 3120)
        
    }
    
    func testGetCurrentPeriodRemainingTimeLunch1() throws {
        let scheduleDay = getCurrentPeriodHelper(date: "2021/05/20 11:10")
        let remainingTimeFirstLunch = try XCTUnwrap(scheduleDay.getCurrentPeriodRemainingTime(selectionMode: .firstLunch))
        let remainingTimeSecondLunch = try XCTUnwrap(scheduleDay.getCurrentPeriodRemainingTime(selectionMode: .secondLunch))
        
        XCTAssertEqual(remainingTimeFirstLunch, 3840)
        XCTAssertEqual(remainingTimeSecondLunch, 1440)
    }
    
    func testGetCurrentPeriodRemainingTimeLunch2() throws {
        let scheduleDay = getCurrentPeriodHelper(date: "2021/01/01 10:30")
        let remainingTimeFirstLunch = try XCTUnwrap(scheduleDay.getCurrentPeriodRemainingTime(selectionMode: .firstLunch))
        let remainingTimeSecondLunch = try XCTUnwrap(scheduleDay.getCurrentPeriodRemainingTime(selectionMode: .secondLunch))
        
        XCTAssertEqual(remainingTimeFirstLunch, 1920)
        XCTAssertEqual(remainingTimeSecondLunch, 3840)
    }
    
    func testGetCurrentPeriodRemainingPercent() throws {
        let scheduleDay = getCurrentPeriodHelper(date: "2021/05/10 11:00")
        //.firstLunchPeriod and .firstLunch in this context should refer to same thing
        let percent = try XCTUnwrap(scheduleDay.getCurrentPeriodRemainingPercent(selectionMode: .firstLunchPeriod))
        let percent2 = try XCTUnwrap(scheduleDay.getCurrentPeriodRemainingPercent(selectionMode: .firstLunch))
        XCTAssertEqual(percent, 0.05)
        XCTAssertEqual(percent2, percent)
    }
    func testParseScheduleData() throws {
        let sampleText = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//Santa Margarita Catholic High School/finalsite//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nX-WR-CALNAME:BELL Schedule\r\nBEGIN:VEVENT\r\nUID:703702@smhsorg.finalsite.com\r\nDTSTAMP:20210421T222201Z\r\nDTSTART;VALUE=DATE:20210322\r\nSUMMARY:SMCHS Events\r\nDESCRIPTION:\\nSpring Recess\\n\\nFaculty/Student Holiday\\n\\nB JV/V Golf @ Ayala Tourn\\n\\nG JV Tennis vs Tesoro 3:00\\n\\nG V Golf vs Aliso Niguel 4:30\\n\\nG V Tennis @ Tesoro 3:00\\n\r\nPRIORITY:0\r\nEND:VEVENT\r\nBEGIN:VEVENT\r\nUID:703695@smhsorg.finalsite.com\r\nDTSTAMP:20210421T222201Z\r\nDTSTART;VALUE=DATE:20210323\r\nSUMMARY:Special Schedule Day 5\r\nDESCRIPTION:Period 5                                   8:00-9:05\\n\\nPeriod 6                                   9:12-10:22 \\n(5 minutes for announcements)\\n\\nNutrition             Period 7 \\n10:22-11:02       10:29-11:34 \\n\\nPeriod 7             Nutrition \\n11:09-12:14      11:34-12:14 \\n\\nPeriod 1                                   12:21-1:26 \\n\\nClass Officer Elections            1:31-2:00 \\n(So/Jr report to Distribution Periods for elections) \\n\\nOffice Hours                            2:05-2:30 \\n------------------------------- \\n\\nClass Officer Elections\\n\\n(So/Jr 8:00-2:00)\\n\\n(Fr/Sr 8:00-1:26)\\n\\nHomecoming Spirit Week\\n\\nB FS/JV/V Soccer @ MD 3:15/7:00/5:00\\n\\nFr/V Baseball @ Dana Hills 3:15/3:15\\n\\nG FS/JV/V Soccer vs MD 3:00/7:15/5:30\\n\\nG JV Tennis @ JSerra 3:00\\n\\nG V Tennis vs JSerra 3:15\\n\\nJV Blue Baseball vs Dana Hills 3:15\\n\\nKairos\\n\\nSball @ San Clemente 3:30\\n\r"
        let expectation = XCTestExpectation(description: "Wait for parsing text")
        var scheduleWeeks: [ScheduleWeek]?
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let mockDate = formatter.date(from: "2021/03/01 09:30")!
        ScheduleDateHelper().parseScheduleData(withRawText: sampleText, mockDate: mockDate){
            scheduleWeeks = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        let unwrappedScheduleWeeks = try XCTUnwrap(scheduleWeeks) 
        let date = formatter.date(from: "2021/03/23 07:00")
        let scheduleDay = try XCTUnwrap(unwrappedScheduleWeeks.first?.scheduleDays.first)
        
        XCTAssertEqual(unwrappedScheduleWeeks.count, 1)
        XCTAssertEqual(scheduleDay.date, date)
        XCTAssertEqual(scheduleDay.scheduleText, "Period 5                                   8:00-9:05\nPeriod 6                                   9:12-10:22 \n(5 minutes for announcements)\nNutrition             Period 7 \n10:22-11:02       10:29-11:34 \nPeriod 7             Nutrition \n11:09-12:14      11:34-12:14 \nPeriod 1                                   12:21-1:26 \nClass Officer Elections            1:31-2:00 \n(So/Jr report to Distribution Periods for elections) \nOffice Hours                            2:05-2:30 \n------------------------------- \nClass Officer Elections\n(So/Jr 8:00-2:00)\n(Fr/Sr 8:00-1:26)\nHomecoming Spirit Week\nB FS/JV/V Soccer @ MD 3:15/7:00/5:00\nFr/V Baseball @ Dana Hills 3:15/3:15\nG FS/JV/V Soccer vs MD 3:00/7:15/5:30\nG JV Tennis @ JSerra 3:00\nG V Tennis vs JSerra 3:15\nJV Blue Baseball vs Dana Hills 3:15\nKairos\nSball @ San Clemente 3:30\n")
    }
    
    func testParseScheduleDataPastDate() throws {
        let sampleText = "BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//Santa Margarita Catholic High School/finalsite//NONSGML v1.0//EN\r\nCALSCALE:GREGORIAN\r\nX-WR-CALNAME:BELL Schedule\r\nBEGIN:VEVENT\r\nUID:703702@smhsorg.finalsite.com\r\nDTSTAMP:20210421T222201Z\r\nDTSTART;VALUE=DATE:20210322\r\nSUMMARY:SMCHS Events\r\nDESCRIPTION:\\nSpring Recess\\n\\nFaculty/Student Holiday\\n\\nB JV/V Golf @ Ayala Tourn\\n\\nG JV Tennis vs Tesoro 3:00\\n\\nG V Golf vs Aliso Niguel 4:30\\n\\nG V Tennis @ Tesoro 3:00\\n\r\nPRIORITY:0\r\nEND:VEVENT\r\nBEGIN:VEVENT\r\nUID:703695@smhsorg.finalsite.com\r\nDTSTAMP:20210421T222201Z\r\nDTSTART;VALUE=DATE:20210323\r\nSUMMARY:Special Schedule Day 5\r\nDESCRIPTION:Period 5                                   8:00-9:05\\n\\nPeriod 6                                   9:12-10:22 \\n(5 minutes for announcements)\\n\\nNutrition             Period 7 \\n10:22-11:02       10:29-11:34 \\n\\nPeriod 7             Nutrition \\n11:09-12:14      11:34-12:14 \\n\\nPeriod 1                                   12:21-1:26 \\n\\nClass Officer Elections            1:31-2:00 \\n(So/Jr report to Distribution Periods for elections) \\n\\nOffice Hours                            2:05-2:30 \\n------------------------------- \\n\\nClass Officer Elections\\n\\n(So/Jr 8:00-2:00)\\n\\n(Fr/Sr 8:00-1:26)\\n\\nHomecoming Spirit Week\\n\\nB FS/JV/V Soccer @ MD 3:15/7:00/5:00\\n\\nFr/V Baseball @ Dana Hills 3:15/3:15\\n\\nG FS/JV/V Soccer vs MD 3:00/7:15/5:30\\n\\nG JV Tennis @ JSerra 3:00\\n\\nG V Tennis vs JSerra 3:15\\n\\nJV Blue Baseball vs Dana Hills 3:15\\n\\nKairos\\n\\nSball @ San Clemente 3:30\\n\r"
        let expectation = XCTestExpectation(description: "Wait for parsing text")
        var scheduleWeeks: [ScheduleWeek]?
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let mockDate = formatter.date(from: "2021/05/01 09:30")!
        ScheduleDateHelper().parseScheduleData(withRawText: sampleText, mockDate: mockDate){
            scheduleWeeks = $0
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 10)
        let unwrappedScheduleWeeks = try XCTUnwrap(scheduleWeeks)
        XCTAssertTrue(unwrappedScheduleWeeks.isEmpty)
    }

    func testHighlightButtonStyle() {
        let view = HighlightButtonStyleTestView()
        assertSnapshot(matching: view, as: .image)
    }

    func testParseGrades() {
        let model = GradesViewModel()
        let grades = CourseGrade([
            .init(periodNum: "1", periodName: "English", gradePercent: 96, currentMark: "A+", gradebookNumber: 6969, code: .current, term: .spring),
            .init(periodNum: "2", periodName: "PE", gradePercent: 90, currentMark: "A-", gradebookNumber: 6965, code: .dropped, term: .spring)])

//        GradesSupplementSummary(period: <#T##Int#>, roomNumber: <#T##String#>, courseNumber: <#T##String#>, courseName: <#T##String#>, courseNumberAndName: <#T##String#>, sectionNumber: <#T##String#>, gradebookName: <#T##JSONNull?#>, gradebookNumber: <#T##JSONNull?#>, teacherName: <#T##String#>, gradebook: <#T##String#>, percent: <#T##String#>, average: <#T##String#>, currentMark: <#T##String#>, currentMarkAndScore: <#T##String#>, currentPercentOrAverage: <#T##String#>, doingMinMax: <#T##Bool#>, trend: <#T##String#>, missingAssignments: <#T##String#>, numMissingAssignments: <#T##Int#>, lastATT: <#T##String#>, lastUpdated: <#T##String#>, totalStudents: <#T##String#>, website: <#T##String#>, accessCode: <#T##String#>, source: <#T##String#>, term: <#T##String#>, termGrouping: <#T##TermGrouping#>, schoolNumber: <#T##Int#>, schoolName: <#T##String#>, schoolSort: <#T##SchoolSort#>, districtCDS: <#T##String#>, districtName: <#T##String#>, editable: <#T##Int#>, block: <#T##Int#>, doingRubric: <#T##Bool#>, termCode: <#T##JSONNull?#>, onlineMeetingURL: <#T##String#>, onlineMeetingAccessCode: <#T##String#>, onlineMeetingSource: <#T##String#>, onlineMeetingPhoneNumber: <#T##String#>, onlineMeetingNote: <#T##String#>, periodTitle: <#T##String#>, flexShortTitle: <#T##JSONNull?#>, flexPeriodStartTime: <#T##FlexPeriodTime#>, flexPeriodEndTime: <#T##FlexPeriodTime#>, students: <#T##JSONNull?#>)
//        let supplement = [GradesSupplementSummary(period: 1, roomNumber: "", courseNumber: "", courseName: "", courseNumberAndName: "", sectionNumber: "", teacherName: "Teacher1", gradebook: "", percent: "96.32", average: "", currentMark: "", currentMarkAndScore: "", currentPercentOrAverage: "", doingMinMax: false, trend: "", missingAssignments: "", numMissingAssignments: 0, lastATT: "", lastUpdated: "May 1", totalStudents: "", website: "", accessCode: "", source: "", term: "", termGrouping: .current, schoolNumber: 0, schoolName: "", schoolSort: .the1, districtCDS: "", districtName: "", editable: 0, block: 0, doingRubric: false, onlineMeetingURL: "", onlineMeetingAccessCode: "", onlineMeetingSource: "", onlineMeetingPhoneNumber: "", onlineMeetingNote: "", periodTitle: "", flexPeriodStartTime: .date62135568000000, flexPeriodEndTime: .date62135568000000),
//
//            GradesSupplementSummary(period: 2, roomNumber: "", courseNumber: "", courseName: "", courseNumberAndName: "", sectionNumber: "", teacherName: "Teacher 2", gradebook: "", percent: "90.2", average: "", currentMark: "", currentMarkAndScore: "", currentPercentOrAverage: "", doingMinMax: false, trend: "", missingAssignments: "", numMissingAssignments: 0, lastATT: "", lastUpdated: "May 2", totalStudents: "", website: "", accessCode: "", source: "", term: "", termGrouping: .current, schoolNumber: 0, schoolName: "", schoolSort: .the1, districtCDS: "", districtName: "", editable: 0, block: 0, doingRubric: false, onlineMeetingURL: "", onlineMeetingAccessCode: "", onlineMeetingSource: "", onlineMeetingPhoneNumber: "", onlineMeetingNote: "", periodTitle: "", flexPeriodStartTime: .date62135568000000, flexPeriodEndTime: .date62135568000000)]
//        model.parseGrades(grades: grades, supplement: supplement)
    }
//    func testTodayView() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        let mockDate = formatter.date(from: "2021/05/10 09:30")!
//        let sampleText = ScheduleViewModel.sampleText
//        let semaphore = DispatchSemaphore(value: 1)
//        let scheduleViewModel = ScheduleViewModel(scheduleDateHelper: ScheduleDateHelper(mockDate: mockDate),
//                                                  downloader: Downloader.mockLoad,
//                                                  purge: true,
//                                                  urlString: sampleText,
//                                                  semaphore: semaphore)
//        semaphore.wait()
//        let todayView = TodayView(scheduleViewViewModel: scheduleViewModel)
//                            .fullFrame()
//                            .environmentObject(UserSettings())
//        let hostingView = UIHostingController(rootView: todayView)
//        assertSnapshot(matching: todayView, as: .image)
//        assertSnapshot(matching: hostingView, as: .recursiveDescription)
//    }
//
//    func testScheduleView() {
//        let view = ScheduleView(scheduleViewModel: ScheduleViewModel.mockScheduleView)
//            .environmentObject(UserSettings())
//        let hostingView = UIHostingController(rootView: view)
//        assertSnapshot(matching: view, as: .image)
//        assertSnapshot(matching: hostingView, as: .recursiveDescription)
//    }
//
//    func testContentView() {
//        let view = ContentView(scheduleViewViewModel: .mockScheduleView, newsViewViewModel: .sampleNewsViewViewModel)
//        let hostingView = UIHostingController(rootView: view)
//        assertSnapshot(matching: view, as: .image, record: true)
//        assertSnapshot(matching: hostingView, as: .recursiveDescription)
//    }
//
//    func testNewsView() {
//        let view = NewsView(newsViewViewModel: .sampleNewsViewViewModel, scheduleViewModel: .mockScheduleView)
//            .fullFrame()
//        let hostingView = UIHostingController(rootView: view)
//        assertSnapshot(matching: view, as: .image)
//        assertSnapshot(matching: hostingView, as: .recursiveDescription)
//    }

//    func testOnboardingViewNew() {
//        let view = OnboardingView(versionStatus: .new, stayInPresentation: .constant(true)).fullFrame()
//        assertSnapshot(matching: view, as: .image(precision: 0.99))
//    }
//
//    func testOnboardingViewUpdate() {
//        let view = OnboardingView(versionStatus: .updated, stayInPresentation: .constant(true)).fullFrame()
//        assertSnapshot(matching: view, as: .image(precision: 0.97))
//    }
    
//    func testScheduleDetailView() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        let date = formatter.date(from: "2021/05/10 16:50")!
//        let view = ScheduleDetailView(scheduleDay: ScheduleDay(id: 1,
//                                                               date: date,
//                                                               scheduleText: "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n",
//                                                               mockDate: date))
//                                .fullFrame()
//        assertSnapshot(matching: view, as: .image, record: true)
//    }
    func testParseClassPeriodRegular() {
        let testScheduleText = "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n"
        let scheduleDay = ScheduleDay(date: Date(), scheduleText: testScheduleText)
        let periods = scheduleDay.parseClassPeriods()
        XCTAssertEqual(scheduleDay.periods, periods)
        
        XCTAssertEqual(periods.first?.periodCategory, .period)
        XCTAssertEqual(periods.first?.periodNumber, 6)
        XCTAssertEqual(periods.first?.startTime, DateFormatter.formatTime12to24("8:00"))
        XCTAssertEqual(periods.first?.endTime, DateFormatter.formatTime12to24("9:05"))
        
        XCTAssertEqual(periods[6].periodNumber, 2)
        XCTAssertEqual(periods[6].periodCategory, .period)
        XCTAssertEqual(periods[6].startTime, DateFormatter.formatTime12to24("12:21"))
        XCTAssertEqual(periods[6].endTime, DateFormatter.formatTime12to24("1:26"))
    }
    
    func testParseClassPeriodLunch() {
        let testScheduleText = "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n"
        let scheduleDay = ScheduleDay(date: Date(), scheduleText: testScheduleText)
        let periods = scheduleDay.parseClassPeriods()
        
        XCTAssertEqual(periods[2].periodCategory, .firstLunch)
        XCTAssertEqual(periods[2].periodNumber, nil)
        XCTAssertEqual(periods[2].startTime, DateFormatter.formatTime12to24("10:22"))
        XCTAssertEqual(periods[2].endTime, DateFormatter.formatTime12to24("11:02"))
        
        XCTAssertEqual(periods[3].periodCategory, .secondLunchPeriod)
        XCTAssertEqual(periods[3].periodNumber, 1)
        XCTAssertEqual(periods[3].startTime, DateFormatter.formatTime12to24("10:29"))
        XCTAssertEqual(periods[3].endTime, DateFormatter.formatTime12to24("11:34"))
        
        XCTAssertEqual(periods[4].periodCategory, .secondLunch)
        XCTAssertEqual(periods[4].periodNumber, nil)
        XCTAssertEqual(periods[4].startTime, DateFormatter.formatTime12to24("11:34"))
        XCTAssertEqual(periods[4].endTime, DateFormatter.formatTime12to24("12:14"))
        
        XCTAssertEqual(periods[5].periodCategory, .firstLunchPeriod)
        XCTAssertEqual(periods[5].periodNumber, 1)
        XCTAssertEqual(periods[5].startTime, DateFormatter.formatTime12to24("11:09"))
        XCTAssertEqual(periods[5].endTime, DateFormatter.formatTime12to24("12:14"))
    }
    
    func testParseClassPeriodOfficeHour() {
        let testScheduleText = "Period 6 8:00-9:05\nPeriod 7 9:12-10:22\n(5 minutes for announcements)\nNutrition                      Period 1\n10:22-11:02                10:29-11:34\nPeriod 1                        Nutrition\n11:09-12:14                 11:34-12:14\nPeriod 2 12:21-1:26\nOffice Hours 1:33-2:30\n-------------------------------\nAP French Lang/Culture & Modern World Hist 8:00\nAP Macroeconomics 12:00\nB FS Golf vs MD 3:30\nB JV Golf @ JSerra 3:00\nB JV Tennis vs Servite 3:15\nB JV/V LAX @ JSerra 7:00/5:30\nB V Tennis @ Servite 2:30\nB V Vball @ JSerra 3:00\nG JV/V LAX @ Orange Luth 7:00/5:30\nG V Golf vs Rosary 4:30\nPossible G Soccer CIF\nSenior Graduation Ticket Distribution\n\nV Wrestling vs Aliso Niguel 1:30\n"
        let scheduleDay = ScheduleDay(date: Date(), scheduleText: testScheduleText)
        let periods = scheduleDay.parseClassPeriods()
        
        XCTAssertEqual(periods[7].periodNumber, nil)
        XCTAssertEqual(periods[7].periodCategory, .officeHour)
        XCTAssertEqual(periods[7].startTime, DateFormatter.formatTime12to24("1:33"))
        XCTAssertEqual(periods[7].endTime, DateFormatter.formatTime12to24("2:30"))
    }
    
    func testParseClassPeriodSingleLunch() {
        var testScheduleText = #"Wednesday\, April 21 \nSpecial Virtual Day 2 \n(40 minute classes) \n\nPeriod 2                         8:00-8:40 \n\nPeriod 3 8:45-9:25 \n(10 minute break) \n\nPeriod 4 9:35-10:15 \n\nPeriod 5                         10:20-11:40 \n(40 minute DIVE Presentation) \n\nNutrition 11:40-12:10 \n\nPeriod 6 12:15-12:55 \n\nPeriod 7 1:00-1:40 \n\nPeriod 1 1:45-2:25"#
        
        testScheduleText = testScheduleText.removingRegexMatches(pattern: #"\\(?!n)"#).removingRegexMatches(pattern: #"\\n"#, replaceWith: "\n").removingRegexMatches(pattern: #"\n\n"#, replaceWith: "\n")
        let scheduleDay = ScheduleDay(date: Date(), scheduleText: testScheduleText)
        let periods = scheduleDay.parseClassPeriods()
        
        XCTAssertEqual(periods[0].periodCategory, .period)
        XCTAssertEqual(periods[0].periodNumber, 2)
        XCTAssertEqual(periods[0].startTime, DateFormatter.formatTime12to24("8:00"))
        XCTAssertEqual(periods[0].endTime, DateFormatter.formatTime12to24("8:40"))
        print(periods)
        XCTAssertEqual(periods[4].periodCategory, .singleLunch)
        XCTAssertEqual(periods[4].periodNumber, nil)
        XCTAssertEqual(periods[4].startTime, DateFormatter.formatTime12to24("11:40"))
        XCTAssertEqual(periods[4].endTime, DateFormatter.formatTime12to24("12:10"))
    }
    func testIsBetweenExtension() {
        var minDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        var maxDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        XCTAssertEqual(Date().isBetween(minDate, and: maxDate), true)
        minDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        maxDate = Calendar.current.date(byAdding: .day, value: 2, to: Date())!
        XCTAssertEqual(Date().isBetween(minDate, and: maxDate), false)
    }
    
    func testPeriodEditable() {
        let userSettings = UserSettings()
        let editable = userSettings.editableSettings
        for index in 1...7 {
            XCTAssertEqual(editable[index-1].periodNumber, index)
            XCTAssertEqual(editable[index-1].textContent, "")
        }
    }
    
//    func testPeriodEditSettingsViewEmpty() {
//        let view = PeriodEditSettingsView(showModal: .constant(true)).fullFrame().environmentObject(UserSettings())
//        assertSnapshot(matching: view, as: .image)
//
//    }
//    func testPeriodEditSettingsViewFilled() {
//        let userSettings = UserSettings()
//        userSettings.editableSettings[0].textContent = "English"
//        userSettings.editableSettings[6].textContent = "P.E."
//        userSettings.editableSettings[3].textContent = "Spanish"
//        let view2 = PeriodEditSettingsView(showModal: .constant(true)).fullFrame().environmentObject(userSettings)
//        assertSnapshot(matching: view2, as: .image)
//        userSettings.resetEditableSettings()
//    }
    func testPeriodEditableReset() {
        let userSettings = UserSettings()
        userSettings.resetEditableSettings()
        let editable = userSettings.editableSettings
        for index in 1...7 {
            XCTAssertEqual(editable[index-1].periodNumber, index)
            XCTAssertEqual(editable[index-1].textContent, "")
        }
        userSettings.editableSettings[0].textContent = "Test Content"
        XCTAssertEqual(userSettings.editableSettings[0].title, "Period 1")
        XCTAssertEqual(userSettings.editableSettings[0].textContent, "Test Content")
        userSettings.resetEditableSettings()
        XCTAssertEqual(userSettings.editableSettings[0].textContent, "")
    }
    
    func testProgressRingWeekend() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        let weekendDateTime = formatter.date(from: "2021/05/02 09:30")!
        let view = ProgressCountDown(selectionMode: .constant(.firstLunch), countDown: .constant(nil), mockDate: weekendDateTime).fullFrame()
        assertSnapshot(matching: view, as: .image(precision: 0.99))
    }
    
//    func testProgressRingUnavailable() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let beforeSchoolDate = formatter.date(from: "2021/05/26 06:16")!
//        let view = ProgressCountDown(scheduleDay: .ampeselectionMode: .constant(.firstLunch), countDown: .constant(nil), mockDate: beforeSchoolDate).fullFrame()
//        assertSnapshot(matching: view, as: .image)
//    }
    
//    func testProgressRing1stLunch() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let weekendDateTime = formatter.date(from: "2021/05/02 09:30")!
//        let view = ProgressCountDown(selectionMode: .constant(.firstLunch), countDown: .constant(nil), mockDate: weekendDateTime).fullFrame()
//        assertSnapshot(matching: view, as: .image)
//    }
//    
//    func testProgressRing2ndLunch() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        let weekendDateTime = formatter.date(from: "2021/05/02 09:30")!
//        let view = ProgressCountDown(selectionMode: .constant(.firstLunch), countDown: .constant(nil), mockDate: weekendDateTime).fullFrame()
//        assertSnapshot(matching: view, as: .image)
//    }
    
//    func testProgressRingPeriod() {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        let date = formatter.date(from: "2021/05/10 16:50")!
//        let scheduleDay = ScheduleDay(date: date, scheduleText: ScheduleDay.sampleScheduleDay.scheduleText, mockDate: date)
//        let view = ProgressRingView(scheduleDay: scheduleDay, selectionMode: .constant(.firstLunch), countDown: TimeInterval(2453), animation: false).fullFrame().environmentObject(UserSettings())
//        assertSnapshot(matching: view, as: .image(precision: 0.99))
//        
//    }
    
//    func testCountDownLongText() throws {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy/MM/dd HH:mm"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0)
//        let date = formatter.date(from: "2021/05/14 08:30")!
//        let scheduleDay = ScheduleDay(id: 1, date: date, scheduleText: ScheduleDay.sampleScheduleDay.scheduleText, mockDate: date)
//        let userSettings = UserSettings()
//        let index = try XCTUnwrap(userSettings.editableSettings.firstIndex(where: {$0.periodNumber == 6}))
//        userSettings.editableSettings[index].textContent = "Adkflas;gjdfigjdfiogjsdfiodgfdgjsoderhjguohdruhdfhu"
//        let view = ProgressRingView(scheduleDay: scheduleDay, selectionMode: .constant(.firstLunch)).fullFrame().environmentObject(userSettings)
//        assertSnapshot(matching: view, as: .image)
//    }
    func testSubHeaderDateText() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let schoolDay = formatter.date(from: "2021/05/10 16:50")!
        let saturday = formatter.date(from: "2021/01/02 13:00")!
        let sunday = formatter.date(from: "2021/02/21 19:11")!
        let scheduleDateHelper1 = ScheduleDateHelper(mockDate: schoolDay)
        let scheduleDateHelper2 = ScheduleDateHelper(mockDate: saturday)
        let scheduleDateHelper3 = ScheduleDateHelper(mockDate: sunday)
        XCTAssertEqual(scheduleDateHelper1.subHeaderText, "Daily Schedule")
        XCTAssertEqual(scheduleDateHelper2.subHeaderText, "School Holiday")
        XCTAssertEqual(scheduleDateHelper3.subHeaderText, "School Holiday")
    }
    
    func testCurrentWeekday() {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let monday = formatter.date(from: "2021/05/10 16:50")!
        let tuesday = formatter.date(from: "2021/05/11 16:50")!
        let wednesday = formatter.date(from: "2021/05/12 16:50")!
        let saturday = formatter.date(from: "2021/05/15 08:00")!
        let scheduleDateHelper1 = ScheduleDateHelper(mockDate: monday)
        let scheduleDateHelper2 = ScheduleDateHelper(mockDate: tuesday)
        let scheduleDateHelper3 = ScheduleDateHelper(mockDate: wednesday)
        let scheduleDateHelper4 = ScheduleDateHelper(mockDate: saturday)
        
        XCTAssertEqual(scheduleDateHelper1.currentWeekday, "Monday")
        XCTAssertEqual(scheduleDateHelper2.currentWeekday, "Tuesday")
        XCTAssertEqual(scheduleDateHelper3.currentWeekday, "Wednesday")
        XCTAssertEqual(scheduleDateHelper4.currentWeekday, "Saturday")
    }

    func testProgressRingNutrition() {
        
    }

    func testComputeOverallPercentage() {
        let assignments: [GradesDetail.Assignment] = [.init(description: "Worksheet #1",
                                                            category: "Assignment",
                                                            numberCorrect: 19,
                                                            numberPossible: 20,
                                                            percent: 19 / 20,
                                                            dateCompleted: "10/12/2022",
                                                            isGraded: true),
                                                      .init(description: "Chapter 1 quiz",
                                                            category: "Test",
                                                            numberCorrect: 28,
                                                            numberPossible: 30,
                                                            percent: 28 / 30,
                                                            dateCompleted: "10/12/2022",
                                                            isGraded: true)]
        let rubric: [GradesRubric] = [.init(category: "Assignment", percentOfGrade: 20, isDoingWeight: true),
                                      .init(category: "Test", percentOfGrade: 80, isDoingWeight: true)]
        let model = GradesDetailViewModel(gradebookNumber: 0, term: "", detailedAssignment: assignments)
        let percentage = model.computeOverallPercentage(with: rubric)
        let mockPercentage = ((19.0 / 20.0) * 20.0 + (28.0 / 30.0) * 80.0)
        XCTAssertEqual(percentage, mockPercentage.truncate(places: 2))

    }

    func testCourseGrade() throws {
        let result = try getDecodedResult(fileName: "GradesSummary", model: CourseGrade.self)
        let courseGrades = result.courses
        XCTAssertEqual(courseGrades[0].periodName, "Broadcast JourH - Spring")
        XCTAssertEqual(courseGrades[1].gradePercentText, "92%")
    }

    func testGradesDetail() throws {
        let result = try getDecodedResult(fileName: "GradesDetail", model: GradesDetail.self)
        let details = result.assignments
        XCTAssertEqual(details[0].description, "Chapter 10 Quiz")
        XCTAssertEqual(details[1].percent, 100.0)
    }

    func testGradesSupplementSummary() throws {
        let result = try getDecodedResult(fileName: "GradesSupplementSummary",
                                          model: [GradesSupplementSummary].self)
        XCTAssertEqual(result[0].teacherName, "KmettK")
        XCTAssertEqual(result[2].teacherName, "FoxG")
    }

    func testGradesRubric() throws {
        let result = try getDecodedResult(fileName: "GradesRubric", model: GradesRubric.Rubric.self)
        let rubrics = result.rubrics
        XCTAssertEqual(rubrics[0].category, "Homework")
        XCTAssertEqual(rubrics[1].percentOfGrade, 10)
    }
    
    func getDecodedResult<T>(fileName: String, model: T.Type)
    throws -> T
    where T: Codable {
        let response = getJSONResponse(for: fileName)
        let decoder = JSONDecoder()
        let result = try decoder.decode(model.self, from: response)
        return result
    }

    func getJSONResponse(for fileName: String) -> Data {
        guard let bundlePath = Bundle(for: type(of: self)).resourcePath
        else {
            preconditionFailure("Cannot find Bundle resource path")
        }
        let url = URL(fileURLWithPath: bundlePath)
                    .appendingPathComponent("JsonResponses")
                    .appendingPathComponent(fileName, isDirectory: false)
                    .appendingPathExtension("json")
        guard let data = try? Data(contentsOf: url)
        else {
            preconditionFailure("Failed to get data from URL \(url)")
        }
        return data
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension View {
    func fullFrame() -> some View {
        self.frame(width: UIScreen.screenWidth, height: UIScreen.screenHeight)
    }
}
