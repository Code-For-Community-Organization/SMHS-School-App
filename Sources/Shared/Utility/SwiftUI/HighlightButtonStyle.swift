//
//  HighlightButtonStyle.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import SwiftUI

struct HighlightButtonStyle: ButtonStyle {
    var foregroundColor: Color = .white
    var backgroundColor: Color = appPrimary
    var horizontalPadding: CGFloat = 100
    var autoWidth: CGFloat {
        min(CGFloat(400), UIScreen.screenWidth - horizontalPadding)
    }
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: autoWidth)
            .padding()
            .background(backgroundColor) 
            .foregroundColor(foregroundColor)
            .clipShape(Capsule(style: .continuous))
            .animatedEffects(configuration)
    }
    
    
}

fileprivate extension View {
    func animatedEffects(_ configuration: ButtonStyleConfiguration) -> some View {
        self
            .brightness(configuration.isPressed ? Double(-0.1) : Double(0))
            .scaleEffect(configuration.isPressed ? CGFloat(0.97) : CGFloat(1))
            .animation(Animation.easeInOut)
    }
}
