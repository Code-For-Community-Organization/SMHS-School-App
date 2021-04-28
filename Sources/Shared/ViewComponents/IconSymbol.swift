//
//  IconSymbol.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/26/21.
//

import SwiftUI
import SFSafeSymbols
struct IconSymbol<Content: View>: View {
    var backgroundColor: Color
    var SFSymbol: Content
    var body: some View {
        Circle()
            .fill(backgroundColor)
            .frame(width: 30, height: 30)
            .overlay(
                SFSymbol
                    .foregroundColor(.white)
            )
    }
}
struct IconSymbol_Previews: PreviewProvider {
    static var previews: some View {
        IconSymbol(backgroundColor: .blue, SFSymbol: Image(systemSymbol: .calendar))
    }
}
