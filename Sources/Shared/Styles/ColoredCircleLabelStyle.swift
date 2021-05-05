//
//  ColoredCircleLabelStyle.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/26/21.
//

import SwiftUI
import SFSafeSymbols

struct ColoredCircleLabelStyle: LabelStyle {
    var color: Color
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            IconSymbol(backgroundColor: color, SFSymbol: configuration.icon)
            configuration.title
                .font(.callout)
        }
    }
}
