//
//  TodayViewViewModel.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/7/21.
//

import Combine
import Foundation
import FirebaseRemoteConfig

class TodayViewViewModel: ObservableObject {
    @Storage(key: "lastAnnoucementTime", defaultValue: nil) private var lastReloadTime: Date?

    @Published var showAnnoucement = false
    @Published var loadingAnnoucements = false
    @Published var showEditModal = false
    @Published var showNetworkError = true
    @Published var showTeamsBanner = true
    @Published var selectionMode: PeriodCategory = .firstLunch
    @Published(key: "announcements") var announcements: [Date: AnnoucementResponse] = [:]
    @Published var lastUpdateTime: Date?

    var mockDate: Date?
    
    var isAnnoucementAvailable: Bool {
        todayAnnoucement != nil
    }
    
    var todayAnnoucement: AnnoucementResponse? {
        announcements[(mockDate ?? Date()).convertToReferenceTime()]
    }

    var todayAnnoucementHTML: String? {
        todayAnnoucement?.getIncreasedFontSizeHTML()
    }

    var lastUpdateDisplay: String {
        if let lastUpdateTime = lastUpdateTime {
            return lastUpdateTime.timeAgoDisplay()
        }
        else {
            return "unknown"
        }
    }

    var anyCancellable: Set<AnyCancellable> = []

    init (mockDate: Date? = nil) {
        self.mockDate = mockDate
        fetchAnnoucements()
        $selectionMode
            .sink {_ in
                var hapticsManager = HapticsManager(impactStyle: .soft)
                hapticsManager.UIFeedbackImpact()
            }
            .store(in: &anyCancellable)
    }

    func updateAnnoucements() {
        #if DEBUG
        fetchAnnoucements()
        #else
        if let time = lastReloadTime {
            //Auto reload every 5 minutes
            if abs(Date().timeIntervalSince(time)) > TimeInterval(60 * 5) {
                fetchAnnoucements()
                lastReloadTime = Date()
            }
        }
        else {
            lastReloadTime = Date()
            fetchAnnoucements()
        }
        #endif
    }

    private func fetchAnnoucements() {
        loadingAnnoucements = true
        let endpoint = Endpoint.getAnnoucements(date: mockDate ?? Date())
        TodayNetworkModel.fetch(with: endpoint.request, type: AnnoucementResponse.self)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] error in
                self?.loadingAnnoucements = false
                switch error {
                    case .finished:
                    self?.lastUpdateTime = Date()
                    case .failure(_):
                        return
                }
            }, receiveValue: {[weak self] announcement in
                let date = DateFormatter().serverTimeFormat(announcement.date)?.convertToReferenceTime()
                guard let announcements = self?.announcements,
                      let date = date else { return }
                if announcements[date] == nil {
                    self?.announcements[date] = announcement
                }
            })
            .store(in: &anyCancellable)
    }

}

extension TodayViewViewModel {
    static let mockViewModel: TodayViewViewModel = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let sampleDate = formatter.date(from: "2021/9/3")!
        return TodayViewViewModel(mockDate: sampleDate)
    }()
}
