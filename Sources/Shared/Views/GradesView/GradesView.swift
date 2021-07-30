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
    
    var body: some View {
        NavigationView {
            ZStack {
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
                    .onAppear(perform: gradesViewModel.reloadData)
                    .blur(radius: gradesViewModel.isLoading ? 20 : 0)
                }
                else {
                    GradesLoginView(gradesViewModel: gradesViewModel)
                    .navigationBarTitle("Grades")
                    .blur(radius: gradesViewModel.isLoading ? 20 : 0)
                }

                if gradesViewModel.isLoading {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                        .foregroundColor(.white)
                        .padding(50)
                        .background(BlurEffect())
                        .blurEffectStyle(.systemThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                        .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                        .transition(AnyTransition.opacity.combined(with: .scale))
                }
            }
            .animation(.easeInOut)
            .disabled(gradesViewModel.isLoading ? true : false)
        }
    }
    
    
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView()
    }
}

