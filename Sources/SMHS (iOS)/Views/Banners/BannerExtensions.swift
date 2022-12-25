//
//  BottomBlur.swift
//  SMHS (iOS)
//
//  Created by Lampeh on 7.08.2022.
//

import SwiftUI
import Kingfisher

//struct WebpProcessor: ImageProcessor {
//
//    // `identifier` should be the same for processors with the same properties/functionality
//    // It will be used when storing and retrieving the image to/from cache.
//    let identifier = "com.yourdomain.webpprocessor"
//
//    // Convert input data/image to target image and return it.
//    func process(item: ImageProcessItem, options: KingfisherParsedOptionsInfo) -> KFCrossPlatformImage? {
//        switch item {
//        case .image(let image):
//            return image
//        case .data(_):
//            return nil
//        }
//    }
//}

struct BannerImage: View {
    let url: URL
    @Binding var selected: Banner?

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
            .aspectRatio(contentMode: .fill)
            .frame(width: 3.0/4.0 * UIScreen.screenWidth,
                   height: 3.0/4.0 * UIScreen.screenWidth)
            .clipped()
            .overlay(
                KFImage(url)
                    .setProcessor(BlurImageProcessor(blurRadius: 65))
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 3.0/4.0 * UIScreen.screenWidth,
                           height: 3.0/4.0 * UIScreen.screenWidth)
                    .clipped()
                    .mask {
                        LinearGradient(stops: [.init(color: .black, location: 0), .init(color: .black, location: 0.1),
                                               .init(color: .clear, location: 0.4), .init(color: .clear, location: 0.8), .init(color: .black, location: 0.95), .init(color: .black, location: 1)], startPoint: .bottom, endPoint: .top)
                    }
                    .opacity(selected == nil ? 1 : 0)

            )
            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
            .shadow(color: Color.appPrimary
                                .makeColor(componentDelta: -0.5)
                                .opacity(0.3),
                    radius: 15, x: 5, y: 5)
    }
}

extension Text {
    func bannerTitle() -> some View {
        self
            .font(.title)
            .fontWeight(.heavy)
            .foregroundColor(.white)
            .multilineTextAlignment(.leading)
    }
    func bannerHeadline() -> some View {
        self
            .font(.body)
            .fontWeight(.semibold)
            .textCase(.uppercase)
            .foregroundColor(.white)
            .multilineTextAlignment(.leading)
            .opacity(0.6)
    }
    
    func bannerFootnote() -> some View {
        self
            .foregroundColor(.white)
            .multilineTextAlignment(.leading)
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

struct BannerImage_Previews: PreviewProvider {
    static var previews: some View {
        let image = URL(string: "https://cdn-ejfid.nitrocdn.com/HahWXuLfKZbQhJjlzjiUHtqlxVqcJYyP/assets/static/optimized/rev-6105aeb/wp-content/uploads/2020/12/topic-faculty-active-engaged-students-1.png")!
        BannerImage(url: image, selected: .constant(nil))
    }
}
