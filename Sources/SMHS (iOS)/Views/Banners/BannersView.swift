//
//  BannersView.swift
//  SMHS (iOS)
//
//  Created by Lampeh on 7.08.2022.
//

import SwiftUI

struct BannersView: View {
    @Binding var banners: [Banner]
    @Binding var selected: Int?
    
    let animate: Namespace.ID
    
    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 5) {
                    ForEach(banners) { banner in
                        let index = banners.firstIndex(where: {$0.id == banner.id})!
                        BannerView(banner: banner, i: index, selected: $selected, animate: animate)
                    }
                }
                .padding(5)
            }
            .frame(height: 320)
        }
    }
}


//struct BannersView_Previews: PreviewProvider {
//    static var previews: some View {
//        BannersView()
//    }
//}
