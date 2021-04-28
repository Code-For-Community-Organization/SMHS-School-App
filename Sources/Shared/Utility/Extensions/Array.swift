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
            if self.count == 0 {
                return nil
            }
            else if self.count == 1 {
                return self[0]
            }
            else {
                return self[self.count-1]
            }
        }
        set {
            guard let newValue = newValue else {return}
            if self.count == 1 {
                self[0] = newValue
            }
            else {
                self[self.count-1] = newValue
            }
        }
    }
}
