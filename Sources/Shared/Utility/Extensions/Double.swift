//
//  Double.swift
//  SMHS
//
//  Created by Jevon Mao on 11/26/21.
//

import Foundation

// https://stackoverflow.com/questions/35946499/how-to-truncate-decimals-to-x-places-in-swift
extension Double {
    func truncate(places : Int)-> Double {
        return Double(floor(pow(10.0, Double(places)) * self)/pow(10.0, Double(places)))
    }
}
