//
//  SocialDetailView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/24/21.
//

import SwiftUI
import SwiftUIVisualEffects

struct SocialDetailView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    var body: some View {
        ScrollView {
            VStack {
                SMStretchyHeader()
                VStack {
                    Text("Social Media")
                        .font(.title, weight: .bold)
                        .textAlign(.leading)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    Text("Tap to get the newest SMCHS updates on social medias.")
                        .font(.callout, weight: .medium)
                        .foregroundColor(.platformSecondaryLabel)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .textAlign(.leading)
                        .padding(.bottom)
                    SocialMediaIcons()
                    Divider()
                    SMHSInformation()
                    Divider()
                    Text("School Location")
                        .font(.title, weight: .bold)
                        .textAlign(.leading)
                        .padding(.vertical)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                    SchoolMapDirections()
                }
                .padding(.horizontal)
                Spacer()
            }
        }
        .overlay(
            BlurEffect()
                .frame(height: UIDevice.hasTopNotch ? 35 : 20)
                .frame(maxWidth: .infinity)
                .blurEffectStyle(.systemUltraThinMaterial),
            alignment: .top
        )
        .edgesIgnoringSafeArea(.top)
    }
}

struct SocialDetailView_Previews: PreviewProvider {
    static var previews: some View {
        SocialDetailView()
    }
}
