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
    var animate: Namespace.ID
    
    var body: some View {
        Button(action: {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55, blendDuration: 1)) {
                selected = banner
            }
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
    }
}

//struct BannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannerView()
//    }
//}
