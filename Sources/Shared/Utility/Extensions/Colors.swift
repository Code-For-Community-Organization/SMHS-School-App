//
//  Colors.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI
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
}
#endif
extension Color {
    static var primary: Color {
        hexStringToColor(hex: "#3498db")
    }
    static var secondary: Color {
        hexStringToColor(hex: "#f39c12")
    }
}

func hexStringToColor (hex: String) -> Color {
    var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return Color.gray
    }

    var rgbValue: UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    let red: Double = Double((rgbValue & 0xFF0000) >> 16)
    let green: Double = Double((rgbValue & 0x00FF00) >> 8)
    let blue: Double = Double(rgbValue & 0x0000FF)
    return Color(.sRGB,
                 red: red / 255.0,
                 green: green / 255.0,
                 blue: blue / 255.0,
                 opacity: 1.0)
}
