//
//  Colors.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
import SwiftUIX
#if canImport(UIKit)
import UIKit

extension Color {
    static var platformBackground: Color {
        Color(UIColor.systemBackground)
    }
    static var platformLabel: Color {
        Color(UIColor.label)
    }
    static var platformSecondaryBackground: Color {
        Color(UIColor.secondarySystemBackground)
    }
    static var platformSecondaryFill: Color {
        Color(UIColor.secondarySystemFill)
    }
    static var platformSecondaryLabel: Color {
        Color(UIColor.secondaryLabel)
    }
    static var platformTertiaryLabel: Color {
        Color(UIColor.tertiaryLabel)
    }

}
#endif

#if canImport(AppKit)
import AppKit

extension Color {
    static var platformBackground: Color {
        Color(NSColor.windowBackgroundColor)
    }
    static var platformLabel: Color {
        Color(NSColor.labelColor)
    }
    static var platformSecondaryBackground: Color {
        Color(NSColor.textBackgroundColor)
    }
    static var platformSecondaryLabel: Color {
        Color(NSColor.secondaryLabelColor)
    }
    static var platformTertiaryLabel: Color {
        Color(NSColor.tertiaryLabelColor)
    }
    
}
#endif
extension Color {
    static var primary: Color {
        Color(hexadecimal: "#3498db")
    }
    static var secondary: Color {
        Color(hexadecimal: "12C4A1")
    }
    static var SMBlue: Color {
        Color(hexadecimal: "0736A4")
    }
}

