//
//  AboutFooterView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/21/21.
//

import SwiftUI

struct AboutFooterView: View {
    @EnvironmentObject var userSettings: UserSettings
    @State var showModal: Bool = false
    var showDivider: Bool = true
    var body: some View {
        VStack {
            if showDivider {
                Divider()
                    .padding(.horizontal)
                    .padding(.top)
            }
            Button(action: {showModal = true}) {
                HStack {
                    Text("About SMHS Schedule")
                        .font(.footnote, weight: .semibold)
                    Image(systemSymbol: .chevronRight)
                        .font(.caption, weight: .medium)
                }
            }
            .padding(EdgeInsets(top: 5, leading: 18, bottom: 30, trailing: 18))
            .textAlign(.leading)
        }
        .sheet(isPresented: $showModal) {FooterModalView().environmentObject(userSettings)}
    }
}

extension View {
    func aboutFooter(showDivider: Bool = true) -> some View {
        ScrollView {
            VStack {
                self
                Spacer()
                AboutFooterView(showDivider: showDivider)
            }
            .frame(maxHeight: .infinity)
        }
    }
}
