//
//  OnboardingRowItem.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 4/30/21.
//

import SwiftUI
import SFSafeSymbols

struct OnboardingRowItem: View {
    var featureDetails: OnboardingFeature
    var isPrimary: Bool

    var body: some View {
        HStack(spacing: 20) {
            featureDetails.symbolImage
                .foregroundColor(isPrimary ? appPrimary : appSecondary)
                .font(.largeTitle)
                .imageScale(.large)
                .frame(maxWidth: 60)

            VStack {
                Text(featureDetails.title)
                    .font(.title3)
                    .fontWeight(.semibold)
                    .textAlign(.leading)
                    .padding(.bottom, 0.5)

                Text(featureDetails.description)
                    .font(.subheadline)
                    .foregroundColor(.platformSecondaryLabel)
                    .textAlign(.leading)
                if let linkTitle = featureDetails.linkTitle,
                   let linkURL = featureDetails.linkURL {
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
        OnboardingRowItem(featureDetails: OnboardingFeature.sampleFeature, isPrimary: true)
    }
}
 
