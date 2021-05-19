//
//  HighlightButtonStyle.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    var foregroundColor: Color = .white
    var backgroundColor: Color = .primary
    var horizontalPadding: CGFloat = 100
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: min(400, UIScreen.screenWidth - horizontalPadding)) 
            .padding()
            .background(backgroundColor) 
            .foregroundColor(foregroundColor)
            .clipShape(Capsule(style: .continuous))
            .brightness(configuration.isPressed ? Double(-0.1) : Double(0))
            .scaleEffect(configuration.isPressed ? CGFloat(0.97) : CGFloat(1))
            .animation(Animation.easeInOut)
    }
}
