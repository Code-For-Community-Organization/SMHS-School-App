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
    @State var lastOffset = CGFloat.zero
    @State var image = Image("SM-Field")
    var body: some View {
        GeometryReader {geo in
            image
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: getHeightForHeaderImage(geo))
                .frame(minWidth: geo.size.width)
                .offset(x: CGFloat(0), y: getOffsetForHeaderImage(geo))
                .overlay(
                    VStack {
                        Spacer()
                        HStack {
                            Image("Logo")
                                .resizable()
                                .aspectRatio(1, contentMode: .fit)
                                .frame(height: 40)
                                .padding(.leading)
                            VStack {
                                Text("Santa Margarita Catholic High School")
                                    .font(.system(.title2, design: .default))
                                    .fontWeight(.bold)
                                    .textAlign(.leading)
                                    .multilineTextAlignment(.leading)
                                Text("The #1 Catholic Coed High School in Southern California.")
                                    .font(.caption, weight: .medium)
                                    .textAlign(.leading)
                                    .multilineTextAlignment(.leading)
                                    .opacity(0.8)
                            }
                            .foregroundColor(.white)
                            .padding()
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(BlurEffect())
                        .offset(x: CGFloat(0), y: getOffsetForHeaderImage(geo))
                        .blurEffectStyle(.systemChromeMaterialDark)
                    }
                )
                .onAppear {
                    image = resizedImage(image: UIImage(named: "SM-Field-HiRes")!, size: geo.size)
                }
        }
        .edgesIgnoringSafeArea(.all)
        .frame(height: 350)
        .frame(maxWidth: .infinity)
    }
    
    //MARK: Stretchy Scroll Header (https://medium.com/swlh/swiftui-create-a-stretchable-header-with-parallax-scrolling-4a98faeeb262)
    func getScrollOffset(_ geometry: GeometryProxy) -> CGFloat {geometry.frame(in: .global).minY}

    private func getOffsetForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset: CGFloat = getScrollOffset(geometry)
        // Image was pulled down
        if offset > 0 {
            print("Offset for image: \(-offset)")
            return -offset
        }
        
        return CGFloat(0)
    }
    private func getHeightForHeaderImage(_ geometry: GeometryProxy) -> CGFloat {
        let offset = getScrollOffset(geometry)
        let imageHeight = geometry.size.height

        if offset > 0 {
            print("Height for image: \(imageHeight + offset)")
            return imageHeight + offset
        }

        return imageHeight
    }
    
    func resizedImage(image: UIImage, size: CGSize) -> Image {
        let renderer = UIGraphicsImageRenderer(size: size)
        let renderedImage = renderer.image {context in
            let rect = AVMakeRect(aspectRatio: image.size,
                                  insideRect: CGRect(origin: .zero,
                                                     size: size))
            image.draw(in: rect)
        }
        return Image(uiImage: renderedImage)
    }
}

struct SMStretchyHeader_Previews: PreviewProvider {
    static var previews: some View {
        SMStretchyHeader()
    }
}
