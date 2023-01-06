//
//  SettingsView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/28/21.
//

import SwiftUI

struct SettingsView<Content: View>: View {
    var content: Content
    init(@ViewBuilder content: () -> Content){
        self.content = content()
    }
    var body: some View {
        List {
            content
        }
        .listStyle(InsetGroupedListStyle())
        
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(content: {EmptyView()})
    }
}
