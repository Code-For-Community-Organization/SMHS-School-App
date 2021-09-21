//
//  HorizontalLabelButton.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftUI
import SFSafeSymbols

struct HorizontalLabelButton: View {
    var label: String
    var symbol: SFSymbol
    var tag: Int
    @Binding var selected: Int
    var body: some View {
        HStack {
            Group {
                Image(systemSymbol: symbol)
                    .font(.system(size: 20))
                    .foregroundColor(appSecondary)
                Text(label)
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(tag == selected ? Color.platformBackground : Color.platformLabel)
            }

        }
        .padding()
        .background(tag == selected ? Color.platformLabel : Color.platformSecondaryFill)
        .roundedCorners(cornerRadius: 10)
        .animation(Animation.easeInOut.speed(1.25))
    }
}

