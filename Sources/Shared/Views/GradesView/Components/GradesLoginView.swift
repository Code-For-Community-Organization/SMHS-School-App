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
                .textFieldStyle(LoginTextFieldRoundedStyle(focused: $gradesViewModel.emailFieldFocused))
                .onTapGesture {
                    gradesViewModel.passwordFieldFocused = false
                    gradesViewModel.emailFieldFocused = true
                }
            
            SecureField("Password", text: $gradesViewModel.password)
                .padding(.bottom, 40)
                .textFieldStyle(LoginTextFieldRoundedStyle(focused: $gradesViewModel.passwordFieldFocused))
                .onTapGesture {
                    gradesViewModel.passwordFieldFocused = true
                    gradesViewModel.emailFieldFocused = false
                }
            
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
        .frame(maxWidth: 350)
        
    }
}

struct LoginTextFieldRoundedStyle: TextFieldStyle {
    @Binding var focused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(focused ? Color.primary : .gray, lineWidth: 3)
            ).padding()
        }
}
