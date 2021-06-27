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
    @State private var textDynamicWidth: CGFloat?
    var body: some View {
        if gradesViewModel.isLoggedIn {
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
                                    .frame(width: textDynamicWidth, alignment: .trailing)
                                    .background(CenteringView())
                            
                        }
                        .padding()
                        .roundedCorners(cornerRadius: 10)
                        .background(.platformBackground)
                    }
                }
                .padding(.horizontal)
            }
            .overlay(
                BlurEffect()
                    .frame(height: UIDevice.hasTopNotch ? 35 : 20)
                    .frame(maxWidth: .infinity)
                    .blurEffectStyle(.systemUltraThinMaterial)
                    .edgesIgnoringSafeArea(.top),
                alignment: .top)
            .background(.platformSecondaryBackground)
            .onPreferenceChange(CenteringColumnPreferenceKey.self) { preferences in
                        for p in preferences {
                            let oldWidth = self.textDynamicWidth ?? .zero
                            if p.width > oldWidth {
                                self.textDynamicWidth = p.width
                            }
                        }
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
struct CenteringColumnPreferenceKey: PreferenceKey {
    typealias Value = [CenteringColumnPreference]

    static var defaultValue: [CenteringColumnPreference] = []

    static func reduce(value: inout [CenteringColumnPreference], nextValue: () -> [CenteringColumnPreference]) {
        value.append(contentsOf: nextValue())
    }
}

struct CenteringColumnPreference: Equatable {
    let width: CGFloat
}

struct CenteringView: View {
    var body: some View {
        GeometryReader { geometry in
            Rectangle()
                .fill(Color.clear)
                .preference(
                    key: CenteringColumnPreferenceKey.self,
                    value: [CenteringColumnPreference(width: geometry.frame(in: CoordinateSpace.global).width)]
                )
        }
    }
}
