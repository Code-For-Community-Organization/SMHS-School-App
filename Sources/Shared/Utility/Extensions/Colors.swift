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

        static var platformSecondaryFill: Color {
            Color(UIColor.secondarySystemFill)
        }

        static var platformSecondaryLabel: Color {
            Color(UIColor.secondaryLabel)
        }

        static var platformTertiaryBackground: Color {
            Color(UIColor.tertiarySystemBackground)
        }

        static var platformTertiaryLabel: Color {
            Color(UIColor.tertiaryLabel)
        }
    }

    public extension Color {
        static var brown: Color {
            .init(.brown)
        }

        static var indigo: Color {
            .init(.systemIndigo)
        }

        static var teal: Color {
            .init(.systemTeal)
        }
    }

    public extension Color {
        static var systemGray2: Color {
            .init(.systemGray2)
        }

        static var systemGray3: Color {
            .init(.systemGray3)
        }

        static var systemGray4: Color {
            .init(.systemGray4)
        }

        static var systemGray5: Color {
            .init(.systemGray5)
        }

        static var systemGray6: Color {
            .init(.systemGray6)
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
public extension Color {
    static var systemRed: Color {
        .init(.systemRed)
    }

    static var systemGreen: Color {
        .init(.systemGreen)
    }

    static var systemBlue: Color {
        .init(.systemBlue)
    }

    static var systemOrange: Color {
        .init(.systemOrange)
    }

    static var systemYellow: Color {
        .init(.systemYellow)
    }

    static var systemPink: Color {
        .init(.systemPink)
    }

    static var systemPurple: Color {
        .init(.systemPurple)
    }

    static var systemTeal: Color {
        .init(.systemTeal)
    }

    static var systemIndigo: Color {
        .init(.systemIndigo)
    }

    static var systemGray: Color {
        .init(.systemGray)
    }

    /// Creates a color from a hexadecimal color code.
    ///
    /// - Parameter hexadecimal: A hexadecimal representation of the color.
    ///
    /// - Returns: A `Color` from the given color code. Returns `nil` if the code is invalid.
    init!(hexadecimal string: String) {
        var string: String = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)

        if string.hasPrefix("#") {
            _ = string.removeFirst()
        }

        if !string.count.isMultiple(of: 2), let last = string.last {
            string.append(last)
        }

        if string.count > 8 {
            string = String(string.prefix(8))
        }

        let scanner = Scanner(string: string)

        var color: UInt64 = 0

        scanner.scanHexInt64(&color)

        if string.count == 2 {
            let mask = 0xFF

            let g = Int(color) & mask

            let gray = Double(g) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
        } else if string.count == 4 {
            let mask = 0x00FF

            let g = Int(color >> 8) & mask
            let a = Int(color) & mask

            let gray = Double(g) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)
        } else if string.count == 6 {
            let mask = 0x0000FF

            let r = Int(color >> 16) & mask
            let g = Int(color >> 8) & mask
            let b = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
        } else if string.count == 8 {
            let mask = 0x0000_00FF

            let r = Int(color >> 24) & mask
            let g = Int(color >> 16) & mask
            let b = Int(color >> 8) & mask
            let a = Int(color) & mask

            let red = Double(r) / 255.0
            let green = Double(g) / 255.0
            let blue = Double(b) / 255.0
            let alpha = Double(a) / 255.0

            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
        } else {
            return nil
        }
    }

    internal static var primary: Color {
        Color("Primary")
    }

    internal static var secondary: Color {
        Color(hexadecimal: "B3A369")
    }

    internal static var SMBlue: Color {
        Color(hexadecimal: "0736A4")
    }
}

/// Foreground colors for static text and related elements.
public extension Color {
    /// The color for text labels that contain primary content.
    static var label: Color {
        #if os(macOS)
            return .init(.labelColor)
        #else
            return .init(.label)
        #endif
    }

    /// The color for text labels that contain secondary content.
    static var secondaryLabel: Color {
        #if os(macOS)
            return .init(.secondaryLabelColor)
        #else
            return .init(.secondaryLabel)
        #endif
    }

    /// The color for text labels that contain tertiary content.
    static var tertiaryLabel: Color {
        #if os(macOS)
            return .init(.tertiaryLabelColor)
        #else
            return .init(.tertiaryLabel)
        #endif
    }

    /// The color for text labels that contain quaternary content.
    static var quaternaryLabel: Color {
        #if os(macOS)
            return .init(.quaternaryLabelColor)
        #else
            return .init(.quaternaryLabel)
        #endif
    }
}
