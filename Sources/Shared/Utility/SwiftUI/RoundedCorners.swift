//
//  RoundedCorners.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/26/21.
//

import Foundation
import SwiftUI

extension View {
    func roundedCorners(cornerRadius: CGFloat) -> some View {
        clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
    }
}
