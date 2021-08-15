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
        TextField(setting.title, text: $setting.textContent)
    }
}

struct PeriodEditItem_Previews: PreviewProvider {
    static var previews: some View {
        PeriodEditItem(setting: .constant(.sampleSetting))
    }
}
