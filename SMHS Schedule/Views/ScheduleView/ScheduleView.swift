//
//  ScheduleView.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

struct ScheduleView: View {
    @StateObject var scheduleViewModel = ScheduleViewModel()
    var parsedICSText: String {
        let rawText = scheduleViewModel.ICSText
        var parsedText = ""
        for line in rawText.lines {
            if line.starts(with: "DTSTART;VALUE=DATE:"){
                let dateString = line.replacingOccurrences(of: "DTSTART;VALUE=DATE:", with: "")
                let formatter = DateFormatter()
                formatter.dateFormat = "yyyyMMdd"
                let date = formatter.date(from: dateString)!
                if Calendar.current.isDateInToday(date) {
                    guard let index = rawText.lines.firstIndex(of: line) else {
                        print("Error getting index")
                        return parsedText
                    }
                    let summary = rawText.lines[index+1].replacingOccurrences(of: "SUMMARY:", with: "")
                    let description = String(rawText.lines[index+2]).replacingOccurrences(of: "DESCRIPTION:", with: "")
                    parsedText += "\(dateString)\n\(summary)\n\(description.removingRegexMatches(pattern: #"\\(?!n)"#).removingRegexMatches(pattern: #"\\n"#, replaceWith: "\n"))"
                    
                }
            }
        }
        return parsedText
    }
    var body: some View {
        VStack{
            Text("Daily Schedule")
                .font(.title) 
                .fontWeight(.bold)
            Text(parsedICSText)
            Spacer()
        }
        
        
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView()
    }
}
extension StringProtocol {
    var lines: [SubSequence] { split(whereSeparator: \.isNewline) }
}

extension String {
    func removingRegexMatches(pattern: String, replaceWith: String = "") -> String {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: .caseInsensitive)
            let range = NSMakeRange(0, count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replaceWith)
        } catch { return self}
    }
}
