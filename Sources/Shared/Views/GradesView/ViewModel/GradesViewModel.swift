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
    @Published(keychain: "email") var email: String = "Jingwen.mao@smhsstudents.org"
    @Published(keychain: "password") var password: String = "Mao511969"
    @Published(key: "gradesResponse") var gradesResponse = [CourseGrade]()
    @Published var errorMessage = ""
    //Whether isLoading to determine showing loading animation
    @Published var isLoading = false
    
    //Remember login status
    @Published(key: "isLoggedIn") var isLoggedIn = false
    
    //Whether email field is focused, used to display textfield color change
    @Published var emailFieldFocused = false
    @Published var passwordFieldFocused = false
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
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] error in
                self?.isLoading = false
                switch error {
                case let .failure(requestError):
                    switch requestError {
                    case .validationError(error: let error):
                        self?.errorMessage = error
                    default:
                        self?.errorMessage = "Unknown error occured."
                    }
                case .finished:
                    break
                }
            }) {[weak self] in
                self?.gradesResponse = $0
                self?.isLoggedIn = true
            }
            .store(in: &anyCancellables)
    }
    
    func signoutAndRemove() {
        email = ""
        password = ""
        gradesResponse = []
        isLoggedIn = false
    }
}


