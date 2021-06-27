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
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var gradesResponse: GradesResponse?
    @Published var error: RequestError?
    
    var anyCancellables: Set<AnyCancellable> = []
    
    init(gradesNetworkModel: GradesNetworkModel = GradesNetworkModel()) {
        self.gradesNetworkModel = gradesNetworkModel
    }
    
    func loginAndFetch() {
        let endpoint = Endpoint.studentLogin(email: email, password: password)
        gradesNetworkModel.fetch(with: endpoint.url, type: GradesResponse.self)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] error in
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


