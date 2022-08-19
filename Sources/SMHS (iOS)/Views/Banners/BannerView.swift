//
//  BannerView.swift
//  SMHS (iOS)
//
//  Created by Lampeh on 7.08.2022.
//

import SwiftUI

struct BannerView: View {
    let banner: Banner
    @Binding var selected: Banner?
    @State var selectedTemp: Banner?
    var animate: Namespace.ID
    
    var body: some View {
        Button(action: {
//            withAnimation(.spring(response: 0.5, dampingFraction: 0.55, blendDuration: 1)) {
//                selected = banner
//            }
            selectedTemp = banner
        }) {
            ZStack(alignment: .topLeading) {
                BannerImage(url: banner.image, selected: $selected)
                VStack(alignment: .leading, spacing: 5) {
                    Text(banner.headline)
                        .bannerHeadline()
                    Text(banner.title)
                        .bannerTitle()
                    Spacer()
                    Text(banner.footnote)
                        .bannerFootnote()
                }
                .padding(10)
            }
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(selected != nil ? 0 : 10)
        }
        .padding(.horizontal, selected != nil ? 0 : 15)
        .fullScreenCover(item: $selectedTemp) {
            if let scheme = $0.externalLink.scheme, scheme == "https" {
                SafariView(url: $0.externalLink)
            }
            else {
                VStack {
                    Text("Unable to open web page. Non-HTTPS URLs are not allowed.")
                        .fontWeight(.semibold)
                        .foregroundColor(.secondaryLabel)

                    Button(action: {selectedTemp = nil}) {
                        Text("Close")
                    }
                    .buttonStyle(HighlightButtonStyle())
                }

            }

        }
    }
}

//struct BannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannerView()
//    }
//}
