//
//  ScheduleListHeaderText.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/18/21.
//

import SwiftUI

struct ScheduleListHeaderText: View {
    var subHeaderText: String
    var body: some View {
        Text(subHeaderText)
            .fontWeight(.semibold)
            .font(.title2)
            .textAlign(.leading)
            .foregroundColor(.platformSecondaryLabel)
    }
}

struct ScheduleListHeaderText_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleListHeaderText(subHeaderText: "May 17")
    }
}
