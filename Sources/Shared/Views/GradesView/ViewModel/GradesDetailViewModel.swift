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
    @Published var isEditModeOn = false
    @Published var overallPercent = 0.0

    var gradebookNumber: Int
    var term: String
    var anyCancellable: Set<AnyCancellable> = []
    let networkingModel = GradesNetworkModel()

//    var overAllPercentage: Double {
//        let total = detailedAssignments.reduce(0.0, {
//            $0 + $1.percent
//        })
//        return 
//    }

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

    func formatUnixDate(_ miliseconds: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(miliseconds / 1000))
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter.string(from: date)
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
                    #if DEBUG
                    print(error)
                    #endif
                }
            }, receiveValue: {[unowned self] receivedGradesDetail in
                let encoder = JSONEncoder()
                let userDefault = UserDefaults.standard
                if let encoded = try? encoder.encode(receivedGradesDetail.assignments) {
                    userDefault.setValue(encoded, forKey: "\(self.gradebookNumber)")
                }
                self.detailedAssignments = receivedGradesDetail.assignments
            })
            .store(in: &anyCancellable)

        let rubricRequest = Endpoint.getGradesRubric(term: term,
                                                     gradebookNumber: String(gradebookNumber))
        AF.request(rubricRequest.request)
            .publishDecodable(type: GradesRubric.self)
            .value()
            .receive(on: RunLoop.main)
            .retry(3)
            .sink(receiveCompletion: {requestError in
                switch requestError {
                case .finished:
                    return
                case .failure(let error):
                    #if DEBUG
                    print(error)
                    #endif
                }

            }, receiveValue: {[weak self] gradesRubric in
                var totalGrade = 0.0
                var totalWeight = 0.0
                for category in gradesRubric.categories {
                    guard category.isDoingWeight else { continue }
                    let correctScore = self?.detailedAssignments
                        .filter {$0.category == category.category}
                        .filter {$0.dateCompleted != nil}
                        .map {$0.numberCorrect}
                        .reduce(0, {$0 + $1})

                    let possibleScore = self?.detailedAssignments
                        .filter {$0.category == category.category}
                        .filter {$0.dateCompleted != nil}
                        .map {$0.numberPossible}
                        .reduce(0, {$0 + $1})

                    guard let _correctScore = correctScore,
                          let _possibleScore = possibleScore
                    else { continue }
                    //guard let _assignments = assignments else { return }
                    let weight = Double(category.percentOfGrade) / 100
                    if _possibleScore > 0 {
                        totalGrade += (_correctScore / _possibleScore) * weight
                        totalWeight += weight
                    }
                }
                let percent = (totalGrade / totalWeight) * 100
                self?.overallPercent = percent.truncate(places: 2)
            })
            .store(in: &anyCancellable)
    }
}

