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
    @Namespace private var viewAnimation
    
    var body: some View {
        NavigationView {
            if gradesViewModel.isLoggedIn {
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(gradesViewModel.gradesResponse.filter{!$0.isPrior}, id: \.self){
                            CourseGradeItem(course: $0)
                        }
                        Button(action: {
                            withAnimation {
                                gradesViewModel.signoutAndRemove()
                            }
                        }) {
                            Text("Log out")
                                .fontWeight(.semibold)
                        }
                        .padding(.top, 20)
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
                }
                .background(.platformSecondaryBackground)
                .navigationBarTitle("Grades")

            }
            else {
                GradesLoginView(gradesViewModel: gradesViewModel, animation: viewAnimation)
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
