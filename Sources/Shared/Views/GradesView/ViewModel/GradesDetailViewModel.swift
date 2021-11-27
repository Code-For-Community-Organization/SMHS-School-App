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
    var overallPercent: Double {
        let userDefault = UserDefaults.standard
        let key = "rubric\(self.gradebookNumber)"
        if let data = userDefault.data(forKey: key),
           let decodedRubric = try? JSONDecoder().decode([GradesRubricRawResponse.Category].self,
                                                         from: data) {
            return computeOverallPercentage(with: decodedRubric)
        }
        else {
            return computeOverallPercentage(with: gradesRubric)
        }
    }

    @Published var gradesRubric = [GradesRubricRawResponse.Category]()
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
        $isEditModeOn
            .sink {[unowned self] isOn in
                if !isOn {
                    let targets = self.detailedAssignments.indices
                        .filter {self.detailedAssignments[$0].editModeDropped}
                    
                    for i in targets {
                        self.detailedAssignments[i].editModeDropped = false
                    }
                }
            }
            .store(in: &anyCancellable)

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

            }, receiveValue: {[unowned self] gradesRubric in
                let encoder = JSONEncoder()
                let userDefault = UserDefaults.standard
                if let encoded = try? encoder.encode(gradesRubric.categories) {
                    userDefault.setValue(encoded, forKey: "rubric\(self.gradebookNumber)")
                }
                self.gradesRubric = gradesRubric.categories

            })
            .store(in: &anyCancellable)
    }

    func computeOverallPercentage(with gradesRubric: [GradesRubricRawResponse.Category]) -> Double {
        var totalGrade = 0.0
        var totalWeight = 0.0
        for category in gradesRubric {
            guard category.isDoingWeight else { continue }
            let correctScore = self.detailedAssignments
                .filter {$0.category == category.category}
                .filter {$0.dateCompleted != nil}
                .filter {
                    if isEditModeOn {
                        return !$0.editModeDropped
                    }
                    return true
                }
                .map {$0.numberCorrect}
                .reduce(0, {$0 + $1})

            let possibleScore = self.detailedAssignments
                .filter {$0.category == category.category}
                .filter {$0.dateCompleted != nil}
                .filter {
                    if isEditModeOn {
                        return !$0.editModeDropped
                    }
                    return true
                }
                .map {$0.numberPossible}
                .reduce(0, {$0 + $1})

            //guard let _assignments = assignments else { return }
            let weight = Double(category.percentOfGrade) / 100
            if possibleScore > 0 {
                totalGrade += (correctScore / possibleScore) * weight
                totalWeight += weight
            }
        }
        let percent = (totalGrade / totalWeight) * 100
        return percent.truncate(places: 2)
    }
}

