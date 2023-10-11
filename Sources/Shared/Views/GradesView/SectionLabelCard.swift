//
//  SectionLabelCard.swift
//  SMHS
//
//  Created by Jevon Mao on 8/22/23.
//

import SwiftUI

struct SectionLabelCard: View {
    var systemName: String
    var text: String

    var body: some View {
        Section {
            HStack {
                LinearGradient(colors: [Color.appPrimary, Color.appSecondary],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing)
                    .mask(Image(systemName: systemName)
                            .imageScale(.large))
                    .frame(width: 50, height: 50)

                Spacer()
                Text(text)
                    .foregroundColor(.secondaryLabel)
                    .padding()
            }
            .font(Font.system(.callout, design: .rounded).weight(.medium))

        }
    }
}

struct SectionLabelCard_Previews: PreviewProvider {
    static var previews: some View {
        SectionLabelCard(systemName: "star.bubble", text: "This beta feature is currently in early access, we are actively working to improve the experience.")
    }
}
