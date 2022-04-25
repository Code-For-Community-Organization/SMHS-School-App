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
import FirebaseAnalytics
import Alamofire

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
    @Published(key: "gradesResponse") var gradesResponse = [CourseGrade.GradeSummary]()
    
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
            if abs(Date().timeIntervalSince(time)) > TimeInterval(globalRemoteConfig.RELOAD_INTERVAL_GRADE) {
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
        registerAnalyticEvent()
        guard !email.isEmpty && !password.isEmpty else {
            return
        }
        isLoading = true
        
        let loginEndpoint = Endpoint.studentLogin(email: email,
                                             password: password,
                                             debugMode: userSettings?.developerSettings.debugNetworking ?? false)
        let getSummaryEndpoint = Endpoint.getGradesSummary()
        let summarySupplementEndpoint = Endpoint.getGradesSummarySupplement()

        let getSummarySupplementPublisher = gradesNetworkModel.fetch(with: summarySupplementEndpoint.request,
                                                                     type: [GradesSupplementSummary].self)

        gradesNetworkModel.fetch(with: loginEndpoint.request)
            .flatMap {[unowned self] _ in
                self.gradesNetworkModel.fetch(with: getSummaryEndpoint.request,
                                              type: CourseGrade.self)
                    .combineLatest(getSummarySupplementPublisher)

            }
            .retry(2)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: {[weak self] completion in
                self?.isLoading = false
                switch completion {
                case let .failure(requestError):
                    self?.networkErrorTitle = "Login Failed"
                    self?.networkErrorMsg = requestError.localizedDescription
                    self?.showNetworkError = true
                case .finished:
                    break
                }
            }) {[weak self] (courseGrades, supplementSummary) in

                let courses = courseGrades.courses
                // Ensure displayed courses are not dropped
                    .filter {$0.code == .current}
                //self?.gradesResponse = courses
                let supplementSummaryCourses = supplementSummary
                    .filter {$0.termGrouping == .current}
                    .filter {summary in
                        let referencePeriods = courses.compactMap{Int($0.periodNum)}
                        return referencePeriods.contains(summary.period)
                    }

                guard supplementSummaryCourses.count == courses.count
                else {
                    self?.gradesResponse = courses
                    return
                }

                self?.gradesResponse = zip(courses, supplementSummaryCourses)
                    .map {(course, supplementSummaryCourse) -> CourseGrade.GradeSummary in
                        var mutableCourse = course
                        if let precisePercent = Double(supplementSummaryCourse.percent) {
                            mutableCourse.gradePercent = precisePercent
                        }
                        mutableCourse.teacherName = supplementSummaryCourse.teacherName
                        mutableCourse.lastUpdated = supplementSummaryCourse.lastUpdated
                        return mutableCourse
                    }
            }
            .store(in: &anyCancellables)

    }
    
    func registerAnalyticEvent() {
        Analytics.logEvent(AnalyticsEventLogin,
                           parameters: ["method": "email"])
    }
    
    func signoutAndRemove() {
        password = ""
        gradesResponse = []
    }
}

extension GradesViewModel {
    
}
