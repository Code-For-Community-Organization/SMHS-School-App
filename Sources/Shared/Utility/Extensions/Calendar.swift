//
//  Calendar.swift
//  SMHS
//
//  Created by Jevon Mao on 3/25/22.
//

import Foundation

extension Calendar {
    // iso8601 calendar counts Monday as
    // 1st day of week, instead of Sunday
    static let iso8601 = Calendar(identifier: .iso8601)
}
