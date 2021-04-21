//
//  ScheduleViewModel.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import Combine
import Foundation

class ScheduleViewModel: ObservableObject {
    var currentWeekday: String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "EEEE"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    @Published var ICSText: String = ""
    var currentDate: String{
        let date = Date()
        let format = DateFormatter()
        format.dateFormat = "MMMM d"
        let formattedDate = format.string(from: date)
        return formattedDate
    }
    init(){
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
    }
    
    func formatMilitaryToStandardTime(_ time: Time) -> String {
        var timeMinutes = time.minutes
        if time.seconds >= 30 {
            timeMinutes += 1
        }
        let dateAsString = "\(time.hours):\(time.minutes)"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date!)
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
