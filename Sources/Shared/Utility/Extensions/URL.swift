//
//  URL.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 7/7/21.
//

import Foundation

extension URL {
    init(unsafeString: String) {
        self.init(string: unsafeString)!
    }
}
