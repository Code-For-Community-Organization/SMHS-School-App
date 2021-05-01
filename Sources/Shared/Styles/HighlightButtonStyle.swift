//
//  HighlightButtonStyle.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: UIScreen.screenWidth - CGFloat(100))
            .padding()
            .background(Color.primary)
            .foregroundColor(Color.platformBackground)
            .clipShape(Capsule(style: .continuous))
            .brightness(configuration.isPressed ? -0.1 : 0)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
            .animation(Animation.easeInOut)
    }
}
