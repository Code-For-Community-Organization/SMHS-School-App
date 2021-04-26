//
//  Array.swift
//  SMHS Schedule
//
//  Created by Jevon Mao on 4/25/21.
//

import Foundation

extension Array {
    var last: Self.Element? {
        get {
            self[self.count-1]
        }
        set {
            guard let newValue = newValue else {return}
            self[self.count-1] = newValue
        }
    }
}
