//
//  ViewExtensions.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 3/15/21.
//

import SwiftUI

extension View {
    func textAlign(_ align: Alignment) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: align)
    }
}
