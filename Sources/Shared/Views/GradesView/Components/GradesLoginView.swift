//
//  GradesLoginView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/28/21.
//

import Introspect
import SwiftUI

struct GradesLoginView: View {
    @ObservedObject var gradesViewModel: GradesViewModel

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Aeries Gradebook Email"),
                        footer: Text(gradesViewModel.emailErrorMsg)
                            .lineLimit(nil)
                            .foregroundColor(.red)) {
                    TextField("School email", text: $gradesViewModel.email)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .keyboardType(.emailAddress)
                        .introspectTextField { textfield in
                            textfield.returnKeyType = .go
                        }
                }
                Section(header: Text("Aeries Gradebook Password"),
                        footer: Text(gradesViewModel.passwordErrorMsg)
                            .lineLimit(nil)
                            .foregroundColor(.red)) {
                    SecureField("Password", text: $gradesViewModel.password)
                        .introspectTextField { textfield in
                            textfield.returnKeyType = .go
                        }
                }
            }
            LoginButton(gradesViewModel: gradesViewModel)
                .animation(nil)
                .opacity(gradesViewModel.isValid ? 1 : 0.3)
                .disabled(gradesViewModel.isValid ? false : true)
        }
        .alert(isPresented: $gradesViewModel.showNetworkError) {
            Alert(title: Text(gradesViewModel.networkErrorTitle),
                  message: Text(gradesViewModel.networkErrorMsg),
                  dismissButton: .cancel())
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
