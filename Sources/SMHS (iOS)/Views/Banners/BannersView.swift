//
//  BannersView.swift
//  SMHS (iOS)
//
//  Created by Lampeh on 7.08.2022.
//

import SwiftUI

struct BannersView: View {
    @Binding var banners: [Banner]
    @Binding var selected: Banner?
    
    let animate: Namespace.ID
    
    var body: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 5) {
                    ForEach(banners.filter{$0.isActive}) { banner in
                        BannerView(banner: banner, selected: $selected, animate: animate)
                            .matchedGeometryEffect(id: banner.id, in: animate, isSource: selected?.id != banner.id)
                    }
                }
                .padding(.horizontal)
            }
            .frame(height: 3.0/4.0 * UIScreen.screenWidth)
    }
}


//struct BannersView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannersView()
//    }
//}
