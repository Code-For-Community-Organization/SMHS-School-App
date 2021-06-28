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
        if gradesViewModel.isLoggedIn {
            GeometryReader {geo in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(gradesViewModel.gradesResponse.filter{!$0.isPrior}, id: \.self){
                            CourseGradeItem(course: $0)
                        }
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
            
        }
        else {
            GradesLoginView(gradesViewModel: gradesViewModel)
        }

    }
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView()
    }
}
