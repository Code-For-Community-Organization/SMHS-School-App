//
//  OnboardingRowItemLegacy.swift
//  SMHS
//
//  Created by Jevon Mao on 9/20/21.
//

import SwiftUI
import SFSafeSymbols

struct OnboardingRowItemLegacy<Content: View>: View {
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
