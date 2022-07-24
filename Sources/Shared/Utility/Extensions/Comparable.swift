//
//  Comparable.swift
//  SMHS
//
//  Created by Jevon Mao on 7/23/22.
//

import Foundation

extension Comparable {
    func clamped(to limits: ClosedRange<Self>) -> Self {
        return min(max(self, limits.lowerBound), limits.upperBound)
    }
}

