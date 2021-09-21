//
//  TeamsJoinBanner.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 9/12/21.
//

import SwiftUI

struct TeamsJoinBanner: View {
    @EnvironmentObject var userSettings: UserSettings

    @State var animate = false
    @Binding var showBanner: Bool
    
    var action: () -> ()
    var body: some View {
        if showBanner {
            VStack {
                VStack {
                    Text("SMHS Teams Available")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.platformBackground)

                    Text("Discuss app related topics, meet the creator, and more.")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.white)
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.top, 0.5)

                    Button(action: {
                        showBanner = false
                        userSettings.didJoinTeams = true
                        action()
                    }) {
                        Text("Join Team")
                            .font(.body)
                            .fontWeight(.semibold)
                            .textCase(nil)
                            .padding(EdgeInsets(top: 8, leading: 30, bottom: 8, trailing: 30))
                    }
                    .background(Color.platformBackground)
                    .foregroundColor(appPrimary)
                    .clipShape(Capsule(style: .continuous))
                    .padding(.top, 5)

                }
                .padding(EdgeInsets(top: 20, leading: 15, bottom: 20, trailing: 15))
            }
            .frame(maxWidth: .infinity)
            .background(LinearGradient(gradient: .init(colors: [appPrimary, appSecondary]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .scaleEffect(x: 1, y: animate ? 1 : 0, anchor: .top)
            .transition(.opacity)
            .onAppear {animate = true}
            .onDisappear {animate = false}
            .padding(.bottom, 3)
            .overlay(closeButton, alignment: .topTrailing)
        }

    }

    var closeButton: some View {
        Button(action: {
            withAnimation {
                showBanner = false
            }

        }, label: {
            Image(systemSymbol: .xmark)
                .font(Font.title3.weight(.semibold))
                .foregroundColor(Color.white.opacity(0.7))
                .padding()
        })

    }
}

struct TeamsJoinBanner_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader {geo in
            TeamsJoinBanner(showBanner: .constant(true), action: {})
        }

    }
}
