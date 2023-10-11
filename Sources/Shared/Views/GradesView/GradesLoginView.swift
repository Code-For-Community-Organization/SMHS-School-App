//
//  GradesLoginView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/28/21.
//

import SwiftUI
import Introspect

struct GradesLoginView: View {
    @StateObject var gradesViewModel: GradesViewModel
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Aeries Email").textCase(nil),
                        footer: Text(gradesViewModel.emailErrorMsg)
                            .lineLimit(nil)
                            .foregroundColor(.red)) {
                    TextField("School email", text: $gradesViewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .submitLabel(.next)

                }
                Section(header: Text("Aeries Password").textCase(nil),
                        footer: Text(gradesViewModel.passwordErrorMsg)
                            .lineLimit(nil)
                            .foregroundColor(.red)) {
                    SecureField("Password", text: $gradesViewModel.password)
                                    .submitLabel(.go)

                }
                Section(content: {EmptyView()}, footer: {
                    LoginButton(gradesViewModel: gradesViewModel)
                        .animation(nil)
                        .opacity(gradesViewModel.isValid ? 1 : 0.3)
                        .disabled(gradesViewModel.isValid ? false : true)
                })
                SectionLabelCard(systemName: "network.badge.shield.half.filled",
                                 text: "Your email and password is always stored locally. Industry standard technology such as HTTPS and AES-256 military grade encryption is used to protect your data.")
                SectionLabelCard(systemName: "star.bubble", text: "This beta feature is currently in early access, we are actively working to improve the experience.")

            }

            
        }
        .alert(isPresented: $gradesViewModel.showNetworkError) {
            Alert(title: Text(gradesViewModel.networkErrorTitle),
                  message: Text(gradesViewModel.networkErrorMsg),
                  dismissButton: .cancel())
        }
        .disabled(gradesViewModel.isLoading)
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
                    .stroke(focused ? Color.appPrimary : .gray, lineWidth: 3)
            ).padding()
    }
}
