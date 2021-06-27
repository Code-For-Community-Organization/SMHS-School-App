//
//  GradesView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import SwiftUI

struct GradesView: View {
    @StateObject var gradesViewModel = GradesViewModel()
    
    var body: some View {
        VStack {
            HStack {
                ForEach(gradesViewModel.gradesResponse.filter{!$0.isPrior}, id: \.self){
                    Text($0.periodName)
                }
            }
            TextField("Email", text: $gradesViewModel.email)
            TextField("Password", text: $gradesViewModel.password)
                .padding(.bottom, 40)
            Button(action: {gradesViewModel.loginAndFetch()}) {
                Group {
                    if gradesViewModel.isLoading {
                        ProgressView().progressViewStyle(CircularProgressViewStyle())
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

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView()
    }
}
