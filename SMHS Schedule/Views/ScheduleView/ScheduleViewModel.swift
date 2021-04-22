//
//  ScheduleViewModel.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Combine
import Foundation

class ScheduleViewModel: ObservableObject {
    //Async loaded value, will not be directly used by view
    @Published var ICSText: String = ""

    var currentWeekday: String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "EEEE"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    var scheduleDays: [ScheduleDay] {
        //ICSText is fetched from networking the calendar ICS URL
        let rawText = ICSText
        var parsedText = [ScheduleDay]()
        for line in rawText.lines {
            //Find line that contains the date
            if line.starts(with: "DTSTART;VALUE=DATE:"){
                //Remove unnecessary text, get date string only
                let dateString = line.replacingOccurrences(of: "DTSTART;VALUE=DATE:", with: "")
                
                //Check if the schedule's date is current date
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                let date = formatter.date(from: dateString)!
                let currentDate = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
                if date >= currentDate {
                    guard let index = rawText.lines.firstIndex(of: line) else {
                        print("Error getting index")
                        return parsedText
                    }
                    //Parse summary, and description (block text of schedule)
                    let summary = rawText.lines[index+1].replacingOccurrences(of: "SUMMARY:", with: "")
                    guard summary.lowercased().contains("day") else {continue}
                    let description = String(rawText.lines[index+2]).replacingOccurrences(of: "DESCRIPTION:", with: "")
                    let scheduleDay = ScheduleDay(date: date,
                                                  scheduleText: "\(summary)\n\(description.removingRegexMatches(pattern: #"\\(?!n)"#).removingRegexMatches(pattern: #"\\n"#, replaceWith: "\n").removingRegexMatches(pattern: #"\n\n"#, replaceWith: "\n"))")
                    parsedText.append(scheduleDay)
                    
                }
            }
        }
        return parsedText
    }
    var currentDate: String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMMM d"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    init(placeholderText: String? = nil){
        guard let text = placeholderText else {
            let url = URL(string: "https://www.smhs.org/calendar/calendar_379.ics")!
            Downloader.load(url: url){data, error in
                guard let data = data else {
                    print("Error occurred while fetching iCS: \(error!)")
                    return
                }
                DispatchQueue.main.async {
                    self.ICSText = String(data: data, encoding: .utf8) ?? ""
                }
            }
            return
        }
        self.ICSText = text
   
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
