//
//  BannerView.swift
//  SMHS (iOS)
//
//  Created by Lampeh on 7.08.2022.
//

import SwiftUI

struct BannerView: View {
    let banner: Banner
    let i: Int
    @Binding var selected: Int?
    var animate: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            BannerImage(url: banner.image)
                .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                .matchedGeometryEffect(id: "image\(i)", in: animate)
                .transition(.identity)
            VStack(alignment: .leading, spacing: 5) {
                Text(banner.headline)
                    .bannerHeadline()
                    .matchedGeometryEffect(id: "headline\(i)", in: animate)
                Text(banner.title)
                    .bannerTitle()
                    .matchedGeometryEffect(id: "title\(i)", in: animate)
                Spacer()
                Text(banner.footnote)
                    .bannerFootnote()
                    .matchedGeometryEffect(id: "footnote\(i)", in: animate)
            }
            .padding(10)
        }
        .aspectRatio(1, contentMode: .fill)
        .ignoresSafeArea()
        .cornerRadius(selected != nil ? 0 : 10)
        .padding(.horizontal, selected != nil ? 0 : 15)
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.55, blendDuration: 1)) {
                selected = i
            }
        }
    }
}

//struct BannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannerView()
//    }
//}
