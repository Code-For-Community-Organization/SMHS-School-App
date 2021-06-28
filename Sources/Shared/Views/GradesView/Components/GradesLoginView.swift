//
//  GradesLoginView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/28/21.
//

import SwiftUI

struct GradesLoginView: View {
    @ObservedObject var gradesViewModel: GradesViewModel
    
    var body: some View {
        VStack {
            TextField("Email", text: $gradesViewModel.email)
            TextField("Password", text: $gradesViewModel.password)
                .padding(.bottom, 40)
            Button(action: {gradesViewModel.loginAndFetch()}) {
                Group {
                    if gradesViewModel.isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle()).foregroundColor(.white)
                    }
                    else {
                        Text("Login")
                            .fontWeight(.semibold)
                    }
                }
            }
            .buttonStyle(HighlightButtonStyle())
        }
        .padding(.horizontal)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .animation(nil)
    }
}

