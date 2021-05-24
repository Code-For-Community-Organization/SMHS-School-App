//
//  FooterModalView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/24/21.
//

import SwiftUI

struct FooterModalView: View {
    var body: some View {
        NavigationView {
            SettingsView {
                Section(header: Label("Statements", systemSymbol: .infoCircle)) {
                    NavigationLink("Why?", destination: Text(""))
                    NavigationLink("How?", destination: Text(""))
                    NavigationLink("The Dev", destination: Text(""))
                }
                
                Section(header: Label("Settings", systemSymbol: .gear)) {
                    NavigationLink("Acknowledgement", destination: Text(""))
                    NavigationLink("Terms of Use", destination: Text(""))
                    NavigationLink("Privacy Policy", destination: Text(""))
                }
            }
            .navigationBarTitle("Settings")
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct FooterModalView_Previews: PreviewProvider {
    static var previews: some View {
        FooterModalView()
    }
}
