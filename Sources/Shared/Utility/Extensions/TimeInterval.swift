//
//  TimeInterval.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/8/21.
//

import Foundation

extension TimeInterval {
    func secondsToHoursMinutesSeconds() -> (Int, Int, Int) { (Int(self) / 3600, (Int(self) % 3600) / 60, (Int(self) % 3600) % 60) }
}
