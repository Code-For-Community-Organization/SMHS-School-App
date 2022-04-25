//
//  SocialMediaLinks.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/24/21.
//

import SwiftUI

struct SocialMediaLinks: View {
    var body: some View {
            VStack {
                Group {
                    HStack {
                        Text("Follow SMCHS")
                            .font(.title3, weight: .semibold)
                        Spacer()
                        NavigationLink(destination: SocialDetailView()) {
                            Text("See More")
                                .foregroundColor(.appPrimary)
                                .font(.callout, weight: .medium)
                        }
                    }
                }
                .padding(.horizontal)
                Divider()
                SocialMediaIcons()
            }
            .edgesIgnoringSafeArea(.horizontal)
            .padding(.vertical)
    }
}

struct SocialMediaLinks_Previews: PreviewProvider {
    static var previews: some View {
        SocialMediaLinks()
    }
}

struct SocialMediaIcon: Hashable {
    var imageName: String
    var url: URL
    init(imageName: String, url: String) {
        self.imageName = imageName
        self.url = URL(string: url)!
    }
}
