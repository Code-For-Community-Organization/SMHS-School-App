//
//  GradesDetailViewModel.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 9/21/21.
//

import Combine
import Foundation
import Alamofire
import SwiftUI

class GradesDetailViewModel: ObservableObject {
    @Published var detailedAssignments = [GradesDetail.Assignment]()

    var gradebookNumber: Int
    var term: String
    var anyCancellable: Set<AnyCancellable> = []
    let networkingModel = GradesNetworkModel()

    init(gradebookNumber: Int, term: String) {
        self.gradebookNumber = gradebookNumber
        self.term = term
        fetchDetailedGrades()
    }

    func fetchDetailedGrades() {
        let gradesRequest = Endpoint.getDetailedGrades(term: term,
                                                       gradebookNumber: String(gradebookNumber))
        let cookies = HTTPCookieStorage.shared
        print(cookies.cookies)
        let body = [
            "requestedPage": "1",
            "term": "F",
            "pageSize": "200",
            "gradebookNumber": String(gradebookNumber)
        ]

        let header: HTTPHeaders = ["Content-Type": "application/json; charset=utf-8"]

        AF.request("https://aeries.smhs.org/parent/m/api/MobileWebAPI.asmx/GetGradebookDetailsData",
                   method: .post,
                   parameters: body,
                   encoder: JSONParameterEncoder.default, headers: header)
            .publishDecodable(type: GradesDetail.self)
            .value()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {requestError in
                switch requestError {
                case .finished:
                    return
                case .failure(let error):
                    print(error)
                }
            }, receiveValue: {[weak self] receivedGradesDetail in
                self?.detailedAssignments = receivedGradesDetail.assignments
            })
            .store(in: &anyCancellable)
    }
}

