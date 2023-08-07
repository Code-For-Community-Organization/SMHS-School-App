//
//  GradesView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import SwiftUI
import SwiftUIVisualEffects

struct GradesView: View {
    @StateObject var gradesViewModel = GradesViewModel()
    @EnvironmentObject var userSettings: UserSettings
    @State var showLoginView = false

    var body: some View {
        NavigationView {
            if showLoginView {
                GradesLoginView(gradesViewModel: gradesViewModel)
                    .navigationBarTitle("Grades")
                    .loadingAnimatable(reload: gradesViewModel.reloadData,
                                       isLoading: $gradesViewModel.isLoading,
                                       shouldReload: .constant(false))
            }
            else {
                ScrollView {
                    VStack(spacing: 17) {
                        ForEach(getCoursesList(), id: \.self){
                            CourseGradeItem(course: $0)
                        }
                        ActionButton(label: "Log Out") {
                            withAnimation {
                                gradesViewModel.showLogoutAlert = true
                            }
                        }
                        .padding(.vertical, 20)
                        .alert(isPresented: $gradesViewModel.showLogoutAlert) {
                            Alert(title: Text("Confirm Log out?"),
                                  message: Text(GradesViewModel.logoutDescription),
                                  primaryButton: .destructive(Text("Log Out"),
                                                              action: {gradesViewModel.signoutAndRemove()}),
                                  secondaryButton: .cancel())
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
                .navigationBarTitle("Grades")
                .loadingAnimatable(reload: gradesViewModel.reloadData,
                                   isLoading: $gradesViewModel.isLoading,
                                   shouldReload: !$gradesViewModel.userInitiatedLogin)
                .padding(.top, 1)
                .onAppear {
                    showLoginView = getCoursesList().isEmpty
                }
                .onDisappear {gradesViewModel.userInitiatedLogin = false}
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: gradesViewModel.gradesResponse) {response in
            showLoginView = response.isEmpty
        }

    }
    
    func getCoursesList() -> [CourseGrade.GradeSummary] {
        if userSettings.developerSettings.dummyGrades {
            return CourseGrade.dummyGrades.courses
        }
        else {
            return gradesViewModel.gradesResponse
        }
    }
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView()
    }
}

