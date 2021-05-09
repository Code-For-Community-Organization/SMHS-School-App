//
//  ScheduleViewModel.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Combine
import SwiftUI
import Foundation

class ScheduleViewModel: ObservableObject {
    @Storage(key: "lastReloadTime", defaultValue: nil) var lastReloadTime: Date?
    @AppStorage("ICSText") var ICSText: String?
    @Published(key: "scheduleWeeks") var scheduleWeeks = [ScheduleWeek]()
    var dateHelper: ScheduleDateHelper = ScheduleDateHelper()
    var currentDaySchedule: ScheduleDay? {
        if Date.currentWeekday <= 5 {
            return scheduleWeeks.first?.scheduleDays.first 
        }
        return nil
    }
    
    init(placeholderText: String? = nil){
        //Handle preview instance with mock placeholder text
        if let text = placeholderText {
            self.ICSText = text
            return
        }
        print("call loadData()")
        fetchData()
    }
    
    func reloadData() {
        print("called reloadData")
        if let time = lastReloadTime {
            if Date().timeIntervalSince(time) > TimeInterval(60) {
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
        print("fetching...")
        let url = URL(string: "https://www.smhs.org/calendar/calendar_379.ics")!
        //Load ICS calendar data from network
        Downloader.load(url: url){data, error in
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
        print("resetting...")
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        ICSText = nil; scheduleWeeks = [];
    }
}



struct Downloader {
    static func load(url: URL, completion: @escaping (Data?, Error?) -> ()) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error!)
                return
            }
            completion(data, nil)
        }
        task.resume()
    }
}
