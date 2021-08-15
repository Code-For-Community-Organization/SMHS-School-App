//
//  ViewExtensions.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

extension View {
    func typeErased() -> AnyView { AnyView(self) }

    // Easily align text to left or right of frame
    @ViewBuilder
    func textAlign(_ align: Alignment) -> some View {
        switch align {
        case .leading:
            HStack {
                self
                Spacer()
            }
        case .trailing:
            HStack {
                Spacer()
                self
            }
        default:
            self
        }
    }
}
