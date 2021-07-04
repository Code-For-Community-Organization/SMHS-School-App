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
        if gradesViewModel.isLoggedIn {
            GeometryReader {geo in
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
                    .padding(.vertical, geo.safeAreaInsets.top)
                }
                .overlay(
                    BlurEffect()
                        .frame(height: UIDevice.hasTopNotch ? 35 : 20)
                        .frame(maxWidth: .infinity)
                        .blurEffectStyle(.systemUltraThinMaterial)
                        .edgesIgnoringSafeArea(.top),
                    alignment: .top)
                .background(.platformSecondaryBackground)
                .edgesIgnoringSafeArea(.top)
            }
            .transition(.slide)
            
        }
        else {
            GradesLoginView(gradesViewModel: gradesViewModel, animation: viewAnimation)
                .transition(.slide)
        }

    }
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView()
    }
}
