//
//  ContentView.swift
//  SMHSSchedule (macOS)
//
//  Created by Jevon Mao on 4/26/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ScheduleView()
            .accentColor(Color.primary)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
