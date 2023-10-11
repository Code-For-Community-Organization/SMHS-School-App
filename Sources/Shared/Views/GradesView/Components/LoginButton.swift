//
//  LoginButton.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 7/26/21.
//

import SwiftUI

struct LoginButton: View {
    @StateObject var gradesViewModel: GradesViewModel
    
    var body: some View {
        Button(action: {
            withAnimation {
                gradesViewModel.userInitiatedLogin = true
                gradesViewModel.loginAndFetch()
            }
        }){
            Text("Log In")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding(10)

        }
        .buttonStyle(.borderedProminent)
        .tint(.appPrimary)
        .disabled(gradesViewModel.isLoading)
        .padding(.horizontal)
    }
}

