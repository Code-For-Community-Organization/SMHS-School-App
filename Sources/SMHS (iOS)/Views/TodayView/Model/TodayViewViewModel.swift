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
    @Published var showAnnoucement = false
    @Published var loadingAnnoucements = false
    @Published var showEditModal = false
    @Published var showNetworkError = true
    @Published var showTeamsBanner = true
    @Published var selectionMode: PeriodCategory = .firstLunch
    @Published(key: "annoucements") var annoucements: [Date: AnnoucementResponse] = [:]

    var mockDate: Date?
    var isAnnoucementAvailable: Bool {
        todayAnnoucement != nil
    }
    
    var todayAnnoucement: AnnoucementResponse? {
        annoucements[(mockDate ?? Date()).convertToReferenceTime()]
    }

    var todayAnnoucementHTML: String? {
        todayAnnoucement?.getIncreasedFontSizeHTML()
    }

    var shouldShowTeams: Bool {
        let shouldShow = globalRemoteConfig.configValue(forKey: "show_join_teams_banner")
        return shouldShow.boolValue
    }
    
    @Published var lastUpdateTime: Date?
    @Storage(key: "lastAnnoucementTime", defaultValue: nil) private var lastReloadTime: Date?
    var anyCancellable: Set<AnyCancellable> = []

    init (mockDate: Date? = nil) {
        self.mockDate = mockDate
        fetchAnnoucements()
    }

    func updateAnnoucements() {
        #if DEBUG
        fetchAnnoucements()
        #else
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

extension TodayViewViewModel {
    static let mockViewModel: TodayViewViewModel = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        let sampleDate = formatter.date(from: "2021/9/3")!
        return TodayViewViewModel(mockDate: sampleDate)
    }()
}
