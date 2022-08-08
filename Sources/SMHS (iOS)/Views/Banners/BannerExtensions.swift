//
//  BottomBlur.swift
//  SMHS (iOS)
//
//  Created by Lampeh on 7.08.2022.
//

import SwiftUI
import Kingfisher

struct BannerImage: View {
    let url: URL
    
    var body: some View {
        KFImage(url)
            .placeholder {
                Color(UIColor.systemGray)
            }
            .retry(maxCount: 3, interval: .seconds(3))
            .onFailure {
                #if DEBUG
                    print("failure: \($0)")
                #endif
                }
            .resizable()
            .shadow(x: 0, y: -10, blur: 15)
            .scaledToFit()
    }
}

extension Text {
    func bannerTitle() -> Text {
        self
            .font(.title2)
            .fontWeight(.bold)
            .foregroundColor(.white)
    }
    func bannerHeadline() -> Text {
        self
            .font(.body)
            .foregroundColor(.gray)
            .fontWeight(.semibold)
    }
    
    func bannerFootnote() -> Text {
        self
            .foregroundColor(.white)
    }
}

extension KFImage {
    func bottomBlurred(level: Int) -> some View {
        return self
            .overlay {
                ForEach(0..<level) { _ in
                    self
                        .blur(radius: 30)
                        .mask {
                            LinearGradient(colors: [.clear, .clear, .clear, .white], startPoint: .top, endPoint: .bottom)
                        }
                }
            }
    }
}
