//
//  ScheduleViewModel.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Combine
import SwiftUI
import Foundation
import FirebaseRemoteConfig
import Alamofire
import SwiftyXMLParser

final class SharedScheduleInformation: ObservableObject {
    @Storage(key: "lastReloadTime", defaultValue: nil) private var lastReloadTime: Date?
    @AppStorage("ICSText") private var ICSText: String?
    @Published var todaySchedule: ScheduleDay?
    @Published(key: "scheduleWeeks") var scheduleWeeks = [ScheduleWeek]()
    @Published var isLoading = false
    @Published(key: "scheduleLastUpdateTime") var scheduleLastUpdateTime: Date? = Date()

    private var currentWeekday: Int?
    
    private var urlString: String = "https://www.smhs.org/calendar/calendar_379.ics"
    var dateHelper: ScheduleDateHelper = ScheduleDateHelper()
    private var downloader: (String, @escaping (Data?, Error?) -> ()) -> () = Downloader.load
    var currentDaySchedule: ScheduleDay? {
        if let today = todaySchedule,
           scheduleWeeks.isEmpty {
            return today
        }
        let targetDay = scheduleWeeks.compactMap{$0.getDayByDate(Date())}
        return targetDay.first
    }

    var scheduleLastUpdateDisplay: String {
        if let lastUpdateTime = scheduleLastUpdateTime {
            return lastUpdateTime.timeAgoDisplay()
        }
        else {
            return "unknown"
        }
    }
    // Fetched through API metadata
    // Represents the start and end of school year
    @Published(key: "minDate") private var minDate: Date? = nil
    @Published(key: "maxDate") private var maxDate: Date? = nil

    init(placeholderText: String? = nil,
         scheduleDateHelper: ScheduleDateHelper = ScheduleDateHelper(),
         downloader: @escaping (String, @escaping (Data?, Error?) -> ()) -> () = Downloader.load,
         purge: Bool = false,
         urlString: String = "https://www.smhs.org/calendar/calendar_379.ics",
         semaphore: DispatchSemaphore? = nil) {
        
        //Handle preview instance with mock placeholder text
        if placeholderText != nil {
            self.ICSText = placeholderText
            return
        }
        if purge {self.lastReloadTime = nil; self.ICSText = nil; self.scheduleWeeks = []}
        self.dateHelper = scheduleDateHelper
        self.urlString = urlString
        self.downloader = downloader
        print("Called reload data from initializer...")
        reloadData()

        // Purge all data when app update applied
        // Allow Remote Config override
        if AppVersionStatus.getVersionStatus() == .updated &&
            Constants.shouldPurgeOnUpdate {
            reset()
        }
    } 
    
    func reloadData() {
        if let time = lastReloadTime {
            // minimum reload interval is 6 hours
            if abs(Date().timeIntervalSince(time)) > Constants.scheduleReloadInterval {
                print("Reload valid, fetching data")
                fetchData(purgeExisting: true)
                lastReloadTime = Date()
            }
        }
        else {
            print("Reload 1st time, fetching data")
            lastReloadTime = Date()
            fetchData(purgeExisting: true)
        }
        
    }
    // Two data sources for schedule:
    // 1. AppServ API (Used by SMHS official app)
    // Preferred because it's more stable and stil
    // works even if smhs.org is down, and it's also
    // more performant as it loads in batches and don't
    // require intensive parsing
    //
    // 2. smhs.org ICS calendar feed, used as a
    // redundency to fallback on if above fails
    func fetchData(startDate: Date = Date().startOfWeek(),
                   purgeExisting: Bool = false,
                   completion: ((Bool) -> Void)? = nil) {
        // AppServ API
        let endpoint = Endpoint.getSchedule(date: startDate)
        isLoading = true
        AF.request(endpoint.request)
            .response {[weak self] response in
            if let data = response.data {
                let xml = XML.parse(data)

                var scheduleDays = [(date: String, schedule: String, title: String)]()
                for day in xml["CALENDAR", "EVENT"] {
                    if let scheduleText = day["DESCRIPTION"].text,
                       let date = day["EVENTDATE"].text,
                       let title = day["TITLE"].text {
                        scheduleDays.append((date, scheduleText, title))
                    }
                }
                let formatter = DateFormatter()
                let metadata = xml["CALENDAR", "METADATA"]
                self?.minDate = formatter.serverTimeFormat(metadata["MINDATE"].text)
                self?.maxDate = formatter.serverTimeFormat(metadata["MAXDATE"].text)
                let fetchedSchedule = self?.dateHelper.parseScheduleXML(forDays: scheduleDays)
                self?.scheduleLastUpdateTime = Date()
                if purgeExisting {
                    self?.scheduleWeeks = fetchedSchedule ?? []
                }
                else {
                    self?.scheduleWeeks.appendUnion(contentsOf: fetchedSchedule)
                }

                self?.isLoading = false
                #if DEBUG
                debugPrint("✅ Successfully fetched from main AppServ API.")
                #endif
                completion?(true)
            }
            else {
                #if DEBUG
                debugPrint("⚠️ Main API failed, fallback on smhs.org ICS calendar feed.")
                #endif
                self?.fetchBackupData() {success in
                    DispatchQueue.main.async {
                        self?.isLoading = false
                    }
                    #if DEBUG
                    if !success {
                        debugPrint("🚨 Main schedule API and fallback API both failed. ")
                    }
                    else {
                        debugPrint("✅ Main API failed, but successfully fetched from backup.")
                    }
                    #endif
                    completion?(success)
                    return
                }
            }
        }
    }

    func fetchBackupData(startDate: Date = Date().startOfWeek(),
                         completion: ((Bool) -> Void)? = nil) {
        // Load ICS calendar data from network
        downloader(urlString){data, error in
            guard let data = data else {
                #if DEBUG
                print("Error occurred while fetching iCS: \(error!)")
                #endif
                completion?(false)
                return
            }
            //Publish changes on main thread
            DispatchQueue.main.async {
                // Decode iCS calendar into raw string
                let rawText = String(data: data, encoding: .utf8) ?? ""
                // Only reload if the downloaded data is different
                guard self.ICSText != rawText
                else {
                    completion?(false)
                    return
                }
                self.ICSText = rawText
                self.dateHelper.parseTodayScheduleData(withRawText: rawText) {day in
                    DispatchQueue.main.async {
                        self.todaySchedule = day
                    }
                }
                self.dateHelper.parseScheduleData(withRawText: rawText){result in
                    DispatchQueue.main.async {
                        self.scheduleWeeks.appendUnion(contentsOf: result)
                        self.objectWillChange.send()
                        completion?(true)
                    }
                }
            }
        }
    }

    func reset() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        ICSText = nil; scheduleWeeks = [];
    }
}



struct Downloader {
    static func load(_ urlString: String, completion: @escaping (Data?, Error?) -> ()) {
        var request = URLRequest(url: URL(string: urlString)!)
        request.allHTTPHeaderFields = ["User-Agent": Constants.userAgent]
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(nil, error!)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
    
    static func mockLoad(_ text: String, completion: @escaping (Data?, Error?) -> ()) {
        completion(text.data(using: .utf8), nil)
    }
}
