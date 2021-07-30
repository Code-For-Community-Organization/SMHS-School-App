//
//  GradesView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import SwiftUI

struct GradesView: View {
    @StateObject var gradesViewModel = GradesViewModel()
    @State var isRefreshing = false
    
    var body: some View {
        NavigationView {
            if !gradesViewModel.gradesResponse.isEmpty {
                ScrollView {
                    LazyVStack(spacing: 20) {
                        ForEach(gradesViewModel.gradesResponse.filter{!$0.isPrior}, id: \.self){
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

            }
            else {
                GradesLoginView(gradesViewModel: gradesViewModel)
                .navigationBarTitle("Grades")

            }
        
        }
    }
    
    
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView()
    }
}

