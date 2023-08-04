//
//  PeriodEditItem.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/13/21.
//

import SwiftUI

struct PeriodEditItem: View {
    @Binding var setting: EditableSetting
    var body: some View {
        VStack {
            TextField(setting.title, text: $setting.subject)
                .disableAutocorrection(true)

            Picker("Room", selection: $setting.room) {
                Text("Select a room").tag(nil as Classroom?)
                ForEach(Classroom.allCases, id: \.self) { room in
                        Text(room.rawValue).tag(room as Classroom?)
                    }
                }
                .pickerStyle(.automatic)
        }

    }
}

struct PeriodEditItem_Previews: PreviewProvider {
    static var previews: some View {
        PeriodEditItem(setting: .constant(.sampleSetting))
    }
}
