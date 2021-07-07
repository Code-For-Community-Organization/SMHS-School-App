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
    var symbol: SFSymbol? = nil
    var tag: NewsCategories
    @Binding var selected: NewsCategories
    
    //Selected color depends on function of button
    //"Special" button has exclusive SFSymbol,
    //and a prominent color
    var body: some View {
        HStack {
            Group {
                if let symbol = symbol {
                    Image(systemSymbol: symbol)
                        .font(.system(size: 20))
                        .foregroundColor(Color.secondary)
                }
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

