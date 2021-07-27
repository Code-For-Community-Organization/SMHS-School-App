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
    var animation: Namespace.ID
    
    var body: some View {
        ZStack {
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
            .blur(radius: gradesViewModel.isLoading ? 20 : 0)
            
            if gradesViewModel.isLoading {
                ProgressView().progressViewStyle(CircularProgressViewStyle())
                    .foregroundColor(.white)
                    .padding(50)
                    .background(.platformSecondaryFill)
                    .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    .shadow(color: Color.black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .transition(AnyTransition.opacity.combined(with: .slide))
            }
         
        }
        .animation(.easeInOut)
        .alert(isPresented: $gradesViewModel.showNetworkError) {
            Alert(title: Text(gradesViewModel.networkErrorTitle),
                  message: Text(gradesViewModel.networkErrorMsg),
                  dismissButton: .cancel())
        }
        .disabled(gradesViewModel.isLoading ? true : false)
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
