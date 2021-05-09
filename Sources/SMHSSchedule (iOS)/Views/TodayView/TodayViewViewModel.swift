//
//  TodayViewViewModel.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/7/21.
//

import Combine
import Foundation

class TodayViewViewModel: ObservableObject {
    var timerCancellable: AnyCancellable?
    var timeRemaining: TimeInterval? {
        didSet {
            timerCancellable = Timer.publish(every: 1, on: .main, in: .default)
                .autoconnect()
                .sink(receiveValue: {_ in
                    if self.timeRemaining! > 0{ 
                        self.timeRemaining! -= 1
                    }
                    else {
                        self.timerCancellable?.cancel()
                    }
                })
        }
    }
    init(timeRemaining: TimeInterval?=nil) {
        self.timeRemaining = timeRemaining
    }
    
    
}
