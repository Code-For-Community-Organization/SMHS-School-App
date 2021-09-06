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
    @Published var showNetworkError = true
    @Published var selectionMode: PeriodCategory = .firstLunch
    @Published var annoucements: [Date: AnnoucementResponse] = [:]
    var todayAnnoucement: AnnoucementResponse? {
        annoucements[Date().convertToReferenceTime()]
    }
    @Published var lastUpdateTime: Date?
    @Storage(key: "lastAnnoucementTime", defaultValue: nil) private var lastReloadTime: Date?
    var anyCancellable: Set<AnyCancellable> = []

    init () {
        fetchAnnoucements()
    }

    func updateAnnoucements() {
        if let time = lastReloadTime {
            //Auto reload every hour
            if abs(Date().timeIntervalSince(time)) > TimeInterval(60 * 60) {
                fetchAnnoucements()
                lastReloadTime = Date()
            }
        }
        else {
            lastReloadTime = Date()
            fetchAnnoucements()
        }
    }

    private func fetchAnnoucements() {
        let endpoint = Endpoint.getAnnoucements(daysFromToday: 1)
        TodayNetworkModel.fetch(with: endpoint.request, type: AnnoucementResponse.self)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] error in
                switch error {
                    case .finished:
                        self?.lastUpdateTime = Date().convertToReferenceTime()
                    case .failure(_):
                        return
                }
            }, receiveValue: {[weak self] annoucement in
                let date = DateFormatter().serverTimeFormat(annoucement.date)?.convertToReferenceTime()
                guard let annoucements = self?.annoucements,
                      let date = date else { return }
                if annoucements[date] == nil {
                    self?.annoucements[date] = annoucement
                }
            })
            .store(in: &anyCancellable)
    }
}
