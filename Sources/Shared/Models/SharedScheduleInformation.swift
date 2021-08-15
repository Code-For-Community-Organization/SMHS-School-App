//
//  ScheduleViewModel.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Combine
import Foundation
import SwiftUI

final class SharedScheduleInformation: ObservableObject {
    @Storage(key: "lastReloadTime", defaultValue: nil) private var lastReloadTime: Date?
    @AppStorage("ICSText") private var ICSText: String?

    @Published(key: "scheduleWeeks") var scheduleWeeks = [ScheduleWeek]()
    // @Published(key: "customSchedules") var customSchedules = [ClassPeriod]()

    private var currentWeekday: Int?

    private var urlString: String = "https://www.smhs.org/calendar/calendar_379.ics"
    var dateHelper = ScheduleDateHelper()
    private var downloader: (String, @escaping (Data?, Error?) -> Void) -> Void = Downloader.load
    var currentDaySchedule: ScheduleDay? {
        let targetDay = scheduleWeeks.compactMap { $0.getDayByDate(Date()) }
        return targetDay.first
    }

    init(placeholderText: String? = nil,
         scheduleDateHelper: ScheduleDateHelper = ScheduleDateHelper(),
         downloader: @escaping (String, @escaping (Data?, Error?) -> Void) -> Void = Downloader.load,
         purge: Bool = false,
         urlString: String = "https://www.smhs.org/calendar/calendar_379.ics",
         semaphore _: DispatchSemaphore? = nil)
    {
        // Handle preview instance with mock placeholder text
        if placeholderText != nil {
            ICSText = placeholderText
            return
        }
        if purge { lastReloadTime = nil; ICSText = nil; scheduleWeeks = [] }
        dateHelper = scheduleDateHelper
        self.urlString = urlString
        self.downloader = downloader
        print("Called fetch data from initializer...")
        fetchData()
    }

    func reloadData() {
        if let time = lastReloadTime {
            if abs(Date().timeIntervalSince(time)) > TimeInterval(120) {
                print("Reload valid, fetching data")
                fetchData()
                lastReloadTime = Date()
            }
            print("Reload invalid")
        } else {
            print("Reload 1st time, fetching data")
            lastReloadTime = Date()
            fetchData()
        }
    }

    func fetchData(completion: ((Bool) -> Void)? = nil) {
        print("Fetching schedule data....")
        // Load ICS calendar data from network
        downloader(urlString) { data, _ in
            guard let data = data else {
                #if DEBUG
                    completion?(false)
                    // print("Error occurred while fetching iCS: \(error!)")
                #endif
                return
            }
            // Publish changes on main thread
            DispatchQueue.main.async {
                let rawText = String(data: data, encoding: .utf8) ?? ""
                guard self.ICSText != rawText else { return }
                self.ICSText = rawText
                // Parse data with fetched result only if ICSText is empty (which likely means 1st time app is opened)
                self.dateHelper.parseScheduleData(withRawText: rawText) { result in
                    DispatchQueue.main.async {
                        self.scheduleWeeks = result
                        self.objectWillChange.send()
                        completion?(true)
                    }
                }
            }
        }
        // 1st attempt at parsing, before networking
        // If ICSText is nil the parsing will fail silently, and fallback on 2nd parsing above
        dateHelper.parseScheduleData(withRawText: ICSText) { result in
            DispatchQueue.main.async {
                self.scheduleWeeks = result
                self.objectWillChange.send()
            }
        }
    }

    func reset() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        ICSText = nil; scheduleWeeks = []
    }
}

enum Downloader {
    static func load(_ urlString: String, completion: @escaping (Data?, Error?) -> Void) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(nil, error!)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }

    static func mockLoad(_ text: String, completion: @escaping (Data?, Error?) -> Void) {
        completion(text.data(using: .utf8), nil)
    }
}
