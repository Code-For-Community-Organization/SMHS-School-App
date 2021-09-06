//
//  FeaturesStatementView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/25/21.
//

import SwiftUI

struct FeaturesStatementView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    var body: some View {
        ScrollView {
            VStack {
                Text("Features of SMHS")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 50)
                VStack(spacing: 35) {
                    OnboardingRowItem(title: "View Schedules",
                                      description: "Schedule for future dates, beautifully grouped by week, easily accesible.",
                                      symbolImage: Image(systemSymbol: .calendar).foregroundColor(.appPrimary).font(.system(size: 50)))
                    OnboardingRowItem(title: "InClass™ Countdown",
                                      description: "Effortlessly find out how much time is left for the current class period.",
                                      symbolImage: Image(systemSymbol: .timerSquare).foregroundColor(.appSecondary).font(.system(size: 50)))
                    OnboardingRowItem(title: "Widgets",
                                      description: "Your daily schedule at a glance with iOS 14 Widgets.",
                                      symbolImage: Image(systemSymbol: .squareDashedInsetFill).foregroundColor(.appPrimary).font(.system(size: 50)))
                    OnboardingRowItem(title: "Campus News",
                                      description: "Get updated on the newest campus news stories, in a supercharged experience.",
                                      symbolImage: Image(systemSymbol: .newspaperFill).foregroundColor(.appSecondary).font(.system(size: 40)))
                    OnboardingRowItem(title: "Nutrition Schedule",
                                      description: "Use a segmented toggle to easily switch between 1st or 2nd lunch.",
                                      symbolImage: Image(systemSymbol: .calendarCircleFill).foregroundColor(.appPrimary).font(.system(size: 50)))
                    OnboardingRowItem(title: "Info Cards",
                                      description: "Tap on the vibrantly colored information cards to quickly link to a SMCHS web page, in app.",
                                      symbolImage: Image(systemSymbol: .squareGrid3x1FillBelowLineGrid1x2).foregroundColor(.appSecondary).font(.system(size: 50)))
                    OnboardingRowItem(title: "Search Bar",
                                      description: "Search for anything, dates, news, SMHS webite...all in the supercharged search bar.",
                                      symbolImage: Image(systemSymbol: .magnifyingglassCircleFill).foregroundColor(.appPrimary).font(.system(size: 50)))
                    OnboardingRowItem(title: "School Information",
                                      description: "Follow SMCHS on social medias! Find basic school directions and contacts in the bottom of search tab.",
                                      symbolImage: Image(systemSymbol: .infoCircleFill).foregroundColor(.appSecondary).font(.system(size: 50)))
                    OnboardingRowItem(title: "Open Source",
                                      description: "SMHS Schedule is fully open source, contributions are welcome on Github.",
                                      symbolImage: Image(systemSymbol: .chevronLeftSlashChevronRight).foregroundColor(.appPrimary).font(.system(size: 40)),
                                      linkTitle: "Learn more.",
                                      linkURL: "https://github.com/jevonmao/SMHS-Schedule")
                }
                
                Spacer()
                Button(action: {presentationMode.wrappedValue.dismiss()}, label: {
                    Text("Close")
                        .font(.body)
                        .fontWeight(.semibold)
                })
                .buttonStyle(HighlightButtonStyle())
                .padding(.vertical)
            }
        }
    }
}

struct FeaturesStatementView_Previews: PreviewProvider {
    static var previews: some View {
        FeaturesStatementView()
    }
}
