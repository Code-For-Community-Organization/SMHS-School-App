//
//  ScheduleViewTextLines.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/1/21.
//

import SwiftUI

struct ScheduleViewTextLines: View {
    var scheduleLines: [Substring]?
    var lineSpacing: CGFloat = 5
    var body: some View {
        VStack {
            if let scheduleLines = scheduleLines {
                ForEach(scheduleLines, id: \.self){
                    SelectableText(String($0), selectable: true)
                        .textAlign(.leading)
                        .padding(.vertical, lineSpacing)
                        .foregroundColor(.platformLabel)
                }
            }
        }
    }
}

struct ScheduleViewTextLines_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleViewTextLines(scheduleLines: [])
    }
}
