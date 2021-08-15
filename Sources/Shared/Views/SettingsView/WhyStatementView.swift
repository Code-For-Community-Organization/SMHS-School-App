//
//  WhyStatementView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/24/21.
//

import func AVFoundation.AVMakeRect
import SwiftUI
import UIKit

struct WhyStatementView: View {
    @State var imageCache = NSCache<NSString, UIImage>()

    var body: some View {
        ScrollView {
            VStack {
                GeometryReader { geo in
                    resizedImage(image: #imageLiteral(resourceName: "Developer_waving"), size: geo.size)
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width)
                }
                .frame(height: 250)
                .edgesIgnoringSafeArea(.top)
                VStack {
                    Text("MISSION STATEMENT")
                        .font(.largeTitle, weight: .bold)
                        .textAlign(.leading)
                        .padding(.bottom)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    Text("""
                    The SMHS app project's mission is to inspire the next generation of student coders and dreamers. SMHS app leads the way as a student created app by providing an enhanced experience to thousands of Santa Margarita Catholic High School students, teachers, and parents.
                    """)
                        .font(.system(.headline, design: .default))
                        .fontWeight(.medium)
                        .textAlign(.leading)
                        .foregroundColor(.platformSecondaryLabel)

                    Text("ABOUT THE APP")
                        .font(.largeTitle, weight: .bold)
                        .textAlign(.leading)
                        .padding(.vertical)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                    Text("""
                    My original motivation was that me as a SMCHS student needed to see the class schedule several times a day. With the official SMHS app as my only option, I quickly noticed issues and nuances where the app left plenty of room for improvements. With my skills of Swift and iOS development, I decided to make a better app from scratch.\n\nFor the 1600 students attending SMHS, this app will greatly enhance students' school experience by providing a one-stop app that offers a variety of features.\n\nWhen compared to the official SMHS app, SMHS Schedule is designed and built to specifically tackle areas that the official app lacked. For example, the official app had the problem of slow loading. Viewing the schedule would required multiple taps to reveal deeply nested navigation menu, and each menu took several seconds of loading. This resulted in a problematic user experience. In my SMHS app, all the schedule information is cached locally to device. Users can easily view schedule that instantly load and is easily accessible on the home screen.
                    """)
                        .font(.system(.headline, design: .default))
                        .fontWeight(.medium)
                        .textAlign(.leading)
                        .foregroundColor(.platformSecondaryLabel)
                    Spacer()
                }
                .padding(.vertical)
                .padding(.horizontal, 25)
                .background(Color.platformBackground)
            }
        }
        .background(Color.platformSecondaryBackground)
        .edgesIgnoringSafeArea(.vertical)
    }

    func resizedImage(image: UIImage, size: CGSize) -> Image {
        guard let cachedImage = imageCache.object(forKey: "mainImage") else {
            let renderer = UIGraphicsImageRenderer(size: size)
            let renderedImage = renderer.image { _ in
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

struct WhyStatementView_Previews: PreviewProvider {
    static var previews: some View {
        WhyStatementView()
    }
}
