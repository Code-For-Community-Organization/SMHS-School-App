//
//  ActionButton.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 7/4/21.
//

import SwiftUI

struct ActionButton: View {
    var label: String
    var foregroundColor: Color = .white
    var backgroundColor: Color = appPrimary
    var horizontalPadding: CGFloat = 100
    var action: () -> Void = {}
    var autoWidth: CGFloat {
        min(CGFloat(400), UIScreen.screenWidth - horizontalPadding)
    }
    var body: some View {
        Button(action: action) {
            Text(label)
                .fontWeight(.semibold)
                .frame(width: autoWidth)
                .padding()
                .background(backgroundColor)
                .foregroundColor(foregroundColor)
                .roundedCorners(cornerRadius: 10)
        }
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        ActionButton(label: "Click Me", action: {})
    }
}
