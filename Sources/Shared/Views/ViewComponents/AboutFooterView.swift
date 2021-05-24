//
//  AboutFooterView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/21/21.
//

import SwiftUI

struct AboutFooterView: View {
    @State var showModal: Bool = false
    
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
        .sheet(isPresented: $showModal) {FooterModalView()}
    }
}

extension View {
    func aboutFooter() -> some View {
        ScrollView {
            VStack {
                self
                Spacer()
                AboutFooterView()
            }
        }
    }
}
