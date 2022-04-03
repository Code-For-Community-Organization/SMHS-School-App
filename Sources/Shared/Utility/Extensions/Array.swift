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
    
    mutating func append(_ newElement: Self.Element?)
    {
        guard let newElement = newElement else {return}
        self.append(newElement)
    }
    
    mutating func append<S>(contentsOf newElements: S?) where Element == S.Element, S : Sequence
    {
        guard let newElements = newElements else {return}
        self.append(contentsOf: newElements)
    }

    mutating func appendUnion<S>(contentsOf newElements: S?) where Element == S.Element,
                                                                   S: Sequence,
                                                                   Element: Equatable
    {
        guard let newElements = newElements else {return}
        self.append(contentsOf: newElements.filter {!self.contains($0)})
    }
}
