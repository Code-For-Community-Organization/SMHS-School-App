//
//  UIDevice.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/31/21.
//

import SwiftUI
import UIKit

extension UIDevice {
    static var hasTopNotch: Bool {
        guard #available(iOS 11.0, *), let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else { return false }
        if UIDevice.current.orientation.isPortrait {
            return window.safeAreaInsets.top >= 44
        } else {
            return window.safeAreaInsets.left > 0 || window.safeAreaInsets.right > 0
        }
    }
}

extension View {
    func onboardingModal() -> some View {
        OnboardingWrapperView(contentView: self)
    }
}
