//
//  BlurEffectView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/27/21.
//

import SwiftUI

struct BlurEffectView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {

    }
}
