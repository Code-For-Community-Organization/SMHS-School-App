//
//  GradesLoginView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/28/21.
//

import SwiftUI
import Introspect

struct GradesLoginView: View {
    @ObservedObject var gradesViewModel: GradesViewModel
    
    var body: some View {
        VStack {
            Form {
                Section {
                    HStack {
                        LinearGradient(colors: [appPrimary, appSecondary],
                                                        startPoint: .topLeading,
                                                        endPoint: .bottomTrailing)
                            .mask(Image(systemName: "network.badge.shield.half.filled")
                                    .imageScale(.large))
                            .frame(width: 50, height: 50)

                        Spacer()
                        Text("Your email and password can never be tracked. Industry standard technology such as HTTPS and AES-256 military grade encryption is used to protect your data.")
                            .foregroundColor(.secondaryLabel)
                            .padding()
                    }
                    .font(Font.system(.callout, design: .rounded).weight(.medium))

                }
                Section(header: Text("Aeries Email").textCase(nil),
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
                Section(header: Text("Aeries Password").textCase(nil),
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
                    .stroke(focused ? appPrimary : .gray, lineWidth: 3)
            ).padding()
    }
}
