//
//  ScheduleViewModel.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Combine
import SwiftUI
import Foundation

final class ScheduleViewModel: ObservableObject {
    @Storage(key: "lastReloadTime", defaultValue: nil) var lastReloadTime: Date?
    @AppStorage("ICSText") var ICSText: String?
    @Published(key: "scheduleWeeks") var scheduleWeeks = [ScheduleWeek]()
    private var currentWeekday: Int?
    var urlString: String = "https://www.smhs.org/calendar/calendar_379.ics"
    var dateHelper: ScheduleDateHelper = ScheduleDateHelper()
    var semaphore: DispatchSemaphore?
    var downloader: (String, @escaping (Data?, Error?) -> ()) -> () = Downloader.load
    var currentDaySchedule: ScheduleDay? {
        let weekday = Date.currentWeekday(for: dateHelper.mockDate ?? Date())
        return (weekday != 0 && weekday != 6) ? scheduleWeeks.first?.scheduleDays.first : nil
    }
    
    init(placeholderText: String? = nil,
         scheduleDateHelper: ScheduleDateHelper = ScheduleDateHelper(),
         downloader: @escaping (String, @escaping (Data?, Error?) -> ()) -> () = Downloader.load,
         purge: Bool = false,
         urlString: String = "https://www.smhs.org/calendar/calendar_379.ics",
         semaphore: DispatchSemaphore? = nil){
        //Handle preview instance with mock placeholder text
        if placeholderText != nil {
            self.ICSText = placeholderText
            return
        }
        if purge {self.lastReloadTime = nil; self.ICSText = nil; self.scheduleWeeks = []}
        self.dateHelper = scheduleDateHelper
        self.urlString = urlString
        self.semaphore = semaphore
        self.downloader = downloader
        fetchData()
    } 
    
    func reloadData() {
        if let time = lastReloadTime {
            if abs(Date().timeIntervalSince(time)) > TimeInterval(60) {
                fetchData()
                lastReloadTime = Date()
                
            }
        }
        else {
            lastReloadTime = Date()
            fetchData()
        }
        
    }
    
    private func fetchData() {
        //Load ICS calendar data from network
        downloader(urlString){data, error in
            guard let data = data else {
                #if DEBUG
                print("Error occurred while fetching iCS: \(error!)")
                #endif
                return
            }
            //Publish changes on main thread
            DispatchQueue.main.async {
                let rawText = String(data: data, encoding: .utf8) ?? ""
                guard self.ICSText != rawText else {return}
                self.ICSText = rawText
                //Parse data with fetched result only if ICSText is empty (which likely means 1st time app is opened)
                self.dateHelper.parseScheduleData(withRawText: rawText){result in
                    DispatchQueue.main.async {
                        self.scheduleWeeks = result
                        self.semaphore?.signal()
                        self.objectWillChange.send()
                    }
                }
            }
        }
        //1st attempt at parsing, before networking
        //If ICSText is nil the parsing will fail silently, and fallback on 2nd parsing above
        dateHelper.parseScheduleData(withRawText: ICSText){result in
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
        ICSText = nil; scheduleWeeks = [];
    }
}



struct Downloader {
    static func load(_ urlString: String, completion: @escaping (Data?, Error?) -> ()) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
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