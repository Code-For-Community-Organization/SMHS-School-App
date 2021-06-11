//
//  SMStretchyHeader.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/25/21.
//

import SwiftUI
import SwiftUIVisualEffects
import UIKit
import func AVFoundation.AVMakeRect

struct SMStretchyHeader: View {
    @State var imageCache = NSCache<NSString, UIImage>()
    var body: some View {
        GeometryReader {geo in
            Group {
                if UIScreen.idiom == .phone {
                    Image("SM-Field-HiRes")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: getHeightForHeaderImage(geo))
                        .offset(x: CGFloat(0), y: Self.getOffsetForHeaderImage(geo))
                        .overlay(HeaderOverlayLabel(geo: geo, stretchy: true))
                }
                else {
                    Image("SM-Field-HiRes")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .overlay(HeaderOverlayLabel(geo: geo, stretchy: false))
                }
            }
        }
        .frame(height: 350)

    }
    
    //MARK: Stretchy Scroll Header (https://medium.com/swlh/swiftui-create-a-stretchable-header-with-parallax-scrolling-4a98faeeb262)
    static func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {geometry.frame(in: .global).minY}

    static func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset: CGFloat = Self.getScrollOffset(geometry)
        // Image was pulled down
        if offset > CGFloat(0) {
            return -offset
        }
        
        return CGFloat(0)
    }
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = Self.getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            return imageHeight + offset
        }

        return imageHeight
    }
    
    func resizedImage(image: UIImage, size: CGSize) -> Image {
        guard let cachedImage = imageCache.object(forKey: "mainImage") else {
            let renderer = UIGraphicsImageRenderer(size: size)
            let renderedImage = renderer.image {context in
                let rect = AVMakeRect(aspectRatio: image.size,
                                      insideRect: CGRect(origin: .zero,
                                                         size: size))
                image.draw(in: rect)
            }
            imageCache.setObject(renderedImage, forKey: "mainImage")
            return Image(uiImage: renderedImage)
        }
        return Image(uiImage: cachedImage)
    }
}

struct SMStretchyHeader_Previews: PreviewProvider {
    static var previews: some View {
        SMStretchyHeader()
    }
}
