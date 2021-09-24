//
//  GradesDetailViewModel.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 9/21/21.
//

import Combine
import Foundation

class GradesDetailViewModel: ObservableObject {
    @Published var detailedAssignments = [GradesDetail.Assignment]()

    var gradebookNumber: String
    var term: String
    var anyCancellable: Set<AnyCancellable> = []
    let networkingModel = GradesNetworkModel()

    init(gradebookNumber: String, term: String) {
        self.gradebookNumber = gradebookNumber
        self.term = term
        fetchDetailedGrades()
    }

    func fetchDetailedGrades() {
        let gradesRequest = Endpoint.getDetailedGrades(term: "", gradebookNumber: "")
        networkingModel.fetch(with: gradesRequest.request, type: GradesDetail.self)
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

