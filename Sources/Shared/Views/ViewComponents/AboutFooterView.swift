//
//  AboutFooterView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/21/21.
//

import SwiftUI

struct AboutFooterView: View {
    @Binding var showModal: Bool
    var body: some View {
        VStack {
            Divider()
                .padding(.horizontal)
                .padding(.top)
            Button(action: {showModal = true}) {
                HStack {
                    Text("About SMHS Schedule")
                        .font(.footnote, weight: .semibold)
                    Image(systemSymbol: .chevronRight)
                        .font(.caption, weight: .medium)
                }
            }
            .padding(EdgeInsets(top: 5, leading: 20, bottom: 30, trailing: 20))
            .textAlign(.leading)
        }
        .background(
            Color.platformSecondaryBackground.edgesIgnoringSafeArea(.all)
        )
    }
}

extension View {
    func aboutFooter(showModal: Binding<Bool>) -> some View {
        VStack {
            self
            Spacer()
            AboutFooterView(showModal: showModal)
        }
    }
}
