//
//  Colors.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

extension Color {
    static var primary: Color{
        hexStringToColor(hex: "007AFF")
    }
    static var secondary: Color{
        hexStringToColor(hex: "00FAFF")
    }
}

func hexStringToColor (hex:String) -> Color {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }

    if ((cString.count) != 6) {
        return Color.gray
    }

    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    return Color(.sRGB,
                 red: Double((rgbValue & 0xFF0000) >> 16) / 255.0,
                 green: Double((rgbValue & 0x00FF00) >> 8) / 255.0,
                 blue: Double(rgbValue & 0x0000FF) / 255.0,
                 opacity: 1)
}
