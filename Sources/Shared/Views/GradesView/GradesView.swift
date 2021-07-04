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
                .padding(.vertical, geo.safeAreaInsets.top + 5)
            }
            .overlay(
                BlurEffect()
                    .frame(height: geo.safeAreaInsets.top)
                    .frame(maxWidth: .infinity)
                    .blurEffectStyle(.systemUltraThinMaterial)
                    .edgesIgnoringSafeArea(.top),
                alignment: .top)
            .background(.platformSecondaryBackground)
            .edgesIgnoringSafeArea(.top)
        }
        .disabled(gradesViewModel.isLoggedIn ? false : true)
        .opacity(gradesViewModel.isLoggedIn ? 1 : 0)
        .overlay(
            GradesLoginView(gradesViewModel: gradesViewModel, animation: viewAnimation)
                .opacity(gradesViewModel.isLoggedIn ? 0 : 1)
        )
    }
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView()
    }
}
