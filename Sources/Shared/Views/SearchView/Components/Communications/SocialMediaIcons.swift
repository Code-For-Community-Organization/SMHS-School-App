//
//  SocialMediaIcons.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/25/21.
//

import SwiftUI

struct SocialMediaIcons: View {
    @Environment(\.openURL) var openURL
    var socialMediaIcons: [SocialMediaIcon] = [.init(imageName: "Facebook", url: "https://www.facebook.com/SMCHSEagles"),
                                               .init(imageName: "Flickr", url: "https://www.flickr.com/photos/46550683@N08/sets/"),
                                               .init(imageName: "Instagram", url: "http://www.instagram.com/santamargaritaeagles/"),
                                               .init(imageName: "Linkedin", url: "https://www.linkedin.com/school/smchseagles/"),
                                               .init(imageName: "Twitter", url: "https://twitter.com/SMCHSEagles")]
    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center) {
                    ForEach(socialMediaIcons, id: \.self) { icon in
                        Spacer()
                        Button(action: { openURL(icon.url) }) {
                            ZStack {
                                Circle()
                                    .fill(Color.white)
                                    .frame(width: 52, height: 52)
                                Image(icon.imageName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 52, height: 52)
                            }
                            .frame(width: 49, height: 49)
                            .clipShape(Circle())
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal)
                .frame(minWidth: geo.size.width)
            }
        }
        .frame(minHeight: 60)
        .fixedSize(horizontal: false, vertical: true)
    }
}

struct SocialMediaIcons_Previews: PreviewProvider {
    static var previews: some View {
        SocialMediaIcons()
    }
}
