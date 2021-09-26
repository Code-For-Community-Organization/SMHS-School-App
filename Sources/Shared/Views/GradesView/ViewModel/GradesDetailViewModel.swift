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
        let userDefault = UserDefaults.standard
        let decoder = JSONDecoder()
        if let cached = userDefault.object(forKey: String(gradebookNumber)) as? Data,
           let decoded = try? decoder.decode([GradesDetail.Assignment].self, from: cached){
            detailedAssignments = decoded
        }
        fetchDetailedGrades()
    }

    func fetchDetailedGrades() {
        let gradesRequest = Endpoint.getDetailedGrades(term: term,
                                                       gradebookNumber: String(gradebookNumber))

        AF.request(gradesRequest.request)
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
            }, receiveValue: {[unowned self] receivedGradesDetail in
                let encoder = JSONEncoder()
                let userDefault = UserDefaults.standard
                if let encoded = try? encoder.encode(receivedGradesDetail) {
                    userDefault.setValue(encoded, forKey: "\(self.gradebookNumber)")
                }
                self.detailedAssignments = receivedGradesDetail.assignments
            })
            .store(in: &anyCancellable)
    }
}

