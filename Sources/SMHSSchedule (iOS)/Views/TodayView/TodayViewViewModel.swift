//
//  TodayViewViewModel.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/7/21.
//

import Combine
import Foundation

class TodayViewViewModel: ObservableObject {
    @Published var showEditModal = false
    @Published var showInfoModal = false
    @Published var selectionMode: PeriodCategory = .firstLunch

}
