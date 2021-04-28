//
//  TextFontExtensions.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/17/21.
//

import SwiftUI

extension Text {
    func calloutText() -> Text {
        self
            .font(.callout)
            .fontWeight(.medium)
    }
    func calloutTextLight() -> Text {
        self
            .font(.callout)
            .fontWeight(.medium)
            .foregroundColor(Color.white.opacity(0.5))
    }
    func titleBold() -> Text {
        self
            .font(.title2)
            .fontWeight(.bold)
    }
}

