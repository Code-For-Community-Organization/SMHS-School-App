//
//  GradesLoginView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/28/21.
//

import SwiftUI

struct GradesLoginView: View {
    @ObservedObject var gradesViewModel: GradesViewModel
    var animation: Namespace.ID
    
    var body: some View {
        VStack {
            TextField("Email", text: $gradesViewModel.email)
                .autocapitalization(.none)
                .disableAutocorrection(true)
                .keyboardType(.emailAddress)
            
            SecureField("Password", text: $gradesViewModel.password)
                .padding(.bottom, 40)
            Button(action: {
                withAnimation {
                    gradesViewModel.loginAndFetch()
                }
            }) {
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
            .disabled(gradesViewModel.isLoading)
        }
        .padding(.horizontal)
        .textFieldStyle(RoundedBorderTextFieldStyle())
        
    }
}

