//
//  ViewExtensions.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

extension View {
    func typeErased() -> AnyView {AnyView(self)}
    
    //Easily align text to left or right of frame
    @ViewBuilder
    func textAlign(_ align: Alignment) -> some View {
        switch align {
        case .leading:
            HStack{
                self
                Spacer()
            }
        case .trailing:
            HStack{
                Spacer()
                self
            }
        default:
            self
        }
    }

    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: @autoclosure () -> Bool,
                                          transform: (Self) -> Content) -> some View {
        if condition() {
            transform(self)
        } else {
            self
        }
    }

    @ViewBuilder func `if`<C1: View, C2: View>(_ condition: @autoclosure () -> Bool,
                                          transform: (Self) -> C1,
                                          elseThen: (Self) -> C2) -> some View {
        if condition() {
            transform(self)
        } else {
            elseThen(self)
        }
    }
}
