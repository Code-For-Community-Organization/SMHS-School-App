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
            Form {
                Section(header: Text("Aeries Gradebook Login"),
                        footer: Text(gradesViewModel.errorMessage)
                                    .lineLimit(nil)
                                    .foregroundColor(.red)) {
                    TextField("School email", text: $gradesViewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .onTapGesture {
                            gradesViewModel.passwordFieldFocused = false
                            gradesViewModel.emailFieldFocused = true
                        }
                    
                    SecureField("Password", text: $gradesViewModel.password)
                        .onTapGesture {
                            gradesViewModel.passwordFieldFocused = true
                            gradesViewModel.emailFieldFocused = false
                        }
                }
            }
            LoginButton(gradesViewModel: gradesViewModel)
            
        }
    }
}

struct LoginTextFieldRoundedStyle: TextFieldStyle {
    @Binding var focused: Bool
    
    func _body(configuration: TextField<Self._Label>) -> some View {
            configuration
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(focused ? Color.primary : .gray, lineWidth: 3)
            ).padding()
        }
}
