//
//  OnboardingRowItem.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import SwiftUI
import SFSafeSymbols

struct OnboardingRowItem<Content: View>: View {
    var title: String
    var description: String
    var symbolImage: Content
    var linkTitle: String?
    var linkURL: String?
    var body: some View {
        HStack(spacing: 20) {
            symbolImage
                .frame(maxWidth: 60)
            VStack {
                Text(title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textAlign(.leading)
                    .padding(.bottom, 0.5)

                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.platformSecondaryLabel)
                    .textAlign(.leading)
                if let linkTitle = linkTitle, let linkURL = linkURL {
                    Link(linkTitle, destination: URL(string: linkURL)!)
                        .font(.footnote)
                        .textAlign(.leading)
                }
            }
        }
        .padding(.horizontal, 25)
    }
}

struct OnboardingRowItem_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingRowItem(title: "View Schedules", description: "Schedule for future dates, beautifully grouped by week, easily accesible on your fingle tips.", symbolImage: Image(systemSymbol: .calendar))
    }
}
 
