//
//  DeveloperTapGesture.swift
//  SMHS
//
//  Created by Jevon Mao on 4/29/22.
//

import SwiftUI

extension View {
    func onDeveloperTap(_ userSettings: UserSettings,
                        count: Int = 5,
                        perform: @escaping () -> Void) -> some View {
        self.onTapGesture(count: 5) {
            perform()
        }
    }
}
