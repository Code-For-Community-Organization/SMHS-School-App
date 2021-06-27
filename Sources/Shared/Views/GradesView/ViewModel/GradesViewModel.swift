//
//  GradesViewModel.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Combine
import Foundation

final class GradesViewModel: ObservableObject {
    var gradesNetworkModel = GradesNetworkModel()
    @Published(key: "email") var email: String = "Jingwen.mao@smhsstudents.org"
    @Published(key: "password") var password: String = "Mao511969"
    @Published(key: "gradesResponse") var gradesResponse = [CourseGrade]()
    @Published var error: RequestError?
    @Published var isLoading = false
    var isLoggedIn: Bool {
        if !email.isEmpty &&
            !password.isEmpty &&
            !gradesResponse.isEmpty {
            return true
        }
        else {
            return false
        }
    }
    
    var anyCancellables: Set<AnyCancellable> = []
    
    init(gradesNetworkModel: GradesNetworkModel = GradesNetworkModel()) {
        self.gradesNetworkModel = gradesNetworkModel
    }
    
    func loginAndFetch() {
        guard !email.isEmpty && !password.isEmpty else {
            return
        }
        isLoading = true
        let endpoint = Endpoint.studentLogin(email: email, password: password)
        gradesNetworkModel.fetch(with: endpoint.url, type: [CourseGrade].self)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] error in
                self?.isLoading = false
                switch error {
                case let .failure(requestError):
                    self?.error = requestError
                case .finished:
                    break
                }
            }) {[weak self] in
                self?.gradesResponse = $0
            }
            .store(in: &anyCancellables)
    }
}

