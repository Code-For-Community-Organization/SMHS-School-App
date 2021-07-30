//
//  GradesViewModel.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import Combine
import Foundation
import Regex
import SwiftUI

final class GradesViewModel: ObservableObject {
    //Networking manager, contains actual HTTPS request methods
    var gradesNetworkModel = GradesNetworkModel()
    @Storage(key: "lastReloadTime", defaultValue: nil) private var lastReloadTime: Date?
    
    //Logout
    @Published var showLogoutAlert = false
    
    static var logoutDescription = """
        Logging out will clear cache of your password and grades data.
        """
    
    //Email, password, gradebook data
    @Published(keychain: "email") var email: String = ""
    @Published(keychain: "password") var password: String = ""
    @Published(key: "gradesResponse") var gradesResponse = [CourseGrade]()
    
    //Form validation errors
    @Published var emailErrorMsg = ""
    @Published var passwordErrorMsg = ""
    @Published var isValid = false
    
    //Networking errors
    @Published var networkErrorTitle = ""
    @Published var networkErrorMsg = ""
    @Published var showNetworkError: Bool = false
    
    //Whether isLoading to determine showing loading animation
    @Published var isLoading = false
    @Published var userInitiatedLogin = false
    
    @Published var userSettings: UserSettings?
    private var anyCancellables: Set<AnyCancellable> = []
    
    init(gradesNetworkModel: GradesNetworkModel = GradesNetworkModel()) {
        self.gradesNetworkModel = gradesNetworkModel
        validateForm
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &anyCancellables)
        
        isEmailValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink {
                if !$0 {
                    self.emailErrorMsg = "Invalid email address, please use your SMHS email."
                }
                else {
                    self.emailErrorMsg = ""
                }
            }
            .store(in: &anyCancellables)
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .sink {
                if !$0 {
                    self.passwordErrorMsg = "Password must not be empty."
                }
                else {
                    self.passwordErrorMsg = ""
                }
            }
            .store(in: &anyCancellables)
    }
}

//MARK: Validation
extension GradesViewModel {
    private func isNotEmptyPublisher(_ publisher: Published<String>.Publisher) -> AnyPublisher<Bool, Never> {
        publisher
            .map{!$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    private var isEmailValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isNotEmptyPublisher($email),
                                 isEmailFormattedPublisher)
            .map{$0 && $1}
            .eraseToAnyPublisher()
    }
    
    private var isEmailFormattedPublisher: AnyPublisher<Bool, Never> {
        $email
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{email in
                let emailRegex = #"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9][0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])"#.r!
                return emailRegex.matches(email)
            }
            .eraseToAnyPublisher()
    }

    private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.1, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{!$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    private var validateForm: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isEmailValidPublisher, isPasswordValidPublisher)
            .map{$0 && $1}
            .eraseToAnyPublisher()
    }
}
//MARK: - Login & Logout methods
extension GradesViewModel {
    
    func reloadData() {
        #if DEBUG
        loginAndFetch()
        #else
        if let time = lastReloadTime {
            if abs(Date().timeIntervalSince(time)) > TimeInterval(60 * 10) {
                loginAndFetch()
                lastReloadTime = Date()
            }
        }
        else {
            lastReloadTime = Date()
            loginAndFetch()
        }
        #endif
    }
    
    func loginAndFetch() {
        guard !email.isEmpty && !password.isEmpty else {
            return
        }
        isLoading = true
        let endpoint = Endpoint.studentLogin(email: email,
                                             password: password,
                                             debugMode: userSettings?.developerSettings.debugNetworking ?? false)
        
        gradesNetworkModel.fetch(with: endpoint.request, type: [CourseGrade].self)
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] error in
                self?.isLoading = false
                switch error {
                case let .failure(requestError):
                    switch requestError {
                    case .validationError(error: let error):
                        self?.networkErrorTitle = "Validation Error"
                        self?.networkErrorMsg = error
                    default:
                        self?.networkErrorTitle = "Unknown error occured."
                    }
                    self?.showNetworkError = true
                case .finished:
                    break
                }
            }) {[weak self] in
                self?.gradesResponse = $0
            }
            .store(in: &anyCancellables)
    }
    
    func signoutAndRemove() {
        password = ""
        gradesResponse = []
    }
}
