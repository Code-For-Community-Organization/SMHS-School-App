//
//  GradesView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 6/27/21.
//

import SwiftUI
import SwiftUIVisualEffects

struct GradesView: View {
    @StateObject var gradesViewModel = GradesViewModel()

    var body: some View {
        if gradesViewModel.isLoggedIn {
            GeometryReader {geo in
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(gradesViewModel.gradesResponse.filter{!$0.isPrior}, id: \.self){course in
                            HStack {
                                VStack {
                                    Group {
                                        Text("PERIOD \(course.periodNum)")
                                            .font(.caption)
                                            .fontWeight(.medium)
                                            .foregroundColor(.platformSecondaryLabel)
                                        Text(course.periodName)
                                            .font(.title2)
                                            .lineLimit(1)
                                            .minimumScaleFactor(0.7)
                                            .padding(.bottom, 1)
                                        Text(course.teacherName)
                                            .font(.subheadline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.platformSecondaryLabel)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                Spacer()
                                Text(course.currentMark)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                
                                    Text("\(course.gradePercent)%")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                
                            }
                            .padding()
                            .background(.platformBackground)
                            .roundedCorners(cornerRadius: 10)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.vertical, geo.safeAreaInsets.top)
                }
                .overlay(
                    BlurEffect()
                        .frame(height: UIDevice.hasTopNotch ? 35 : 20)
                        .frame(maxWidth: .infinity)
                        .blurEffectStyle(.systemUltraThinMaterial)
                        .edgesIgnoringSafeArea(.top),
                    alignment: .top)
                .background(.platformSecondaryBackground)
                .edgesIgnoringSafeArea(.top)
            }
            
        }
        else {
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
}

struct GradesView_Previews: PreviewProvider {
    static var previews: some View {
        GradesView()
    }
}
