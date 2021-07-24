//
//  HowStatementView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/24/21.
//

import SwiftUI
import func AVFoundation.AVMakeRect

struct HowStatementView: View {
    
    @State var imageCache = NSCache<NSString, UIImage>()
    var body: some View {
        ScrollView {
            VStack {
                GeometryReader {geo in
                    resizedImage(image: UIImage(named: "Developer_thumbs")!, size: geo.size)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width)
                }
                .frame(height: 250)
                .edgesIgnoringSafeArea(.top)
                
                Text("HOW DOES\nSMHS WORK?")
                    .font(.largeTitle, weight: .bold)
                    .padding(.bottom)
                    .textAlign(.leading)
                    .lineLimit(2)
                    .minimumScaleFactor(0.5)
                VStack {
                    Text("How Does SMHS work?")
                        .font(.title2, weight: .bold)
                        .padding(.top)
                        .foregroundColor(.platformLabel)
                        .textAlign(.leading)
                        .padding(.bottom, 2)

                    Text("The SMHS app will always be just as trustworthy as SMCHS's official website and app. We fetch information directly from the website, and constantly gets the newest schedule information everytime you open the app.")
                    
                    Text("SMHS on a Technical Level")
                        .font(.title2, weight: .bold)
                        .padding(.top)
                        .foregroundColor(.platformLabel)
                        .textAlign(.leading)
                        .padding(.bottom, 2)

                    Text("Keep reading if you want to learn more about the technical implementations of SMHS on the programming level.\n\nFor the schedule information (campus news please read following section), the answers lies in the calendar feed, or .ICS iCalendar files. On the bell schedule page of the SMHS's website, there is a button that gives the calendar feed.\n\niCalendar file is a standard media type for exchanging scheduling information, and this means SMHS Schedule can simply periodically download the .ICS file as a raw text, to get updated schedule information.\n\nIn fact, you can click on this link to download the .ICS file and right click to open it as a text file on your computer. This resembles the raw text that SMHS Schdeule will parse.")
                        .textAlign(.leading)

                    Text("Scraping SMHS Website")
                        .font(.title2, weight: .bold)
                        .padding(.top)
                        .foregroundColor(.platformLabel)
                        .textAlign(.leading)
                        .padding(.bottom, 2)
                    
                    Text("For fetching the campus news, SMHS Schedule uses a 2 step process.\n\nFirst, the app uses networking functions to download an XML file from SMHS website. This XML file is structured similarly to a json file while using HTML style tag syntax, and contains important meta information for news article entries. For each of the new article entry contained in the XML file, it records the title, author, date, image url, and article url. The app will parse and extract those information into models for further logics and rendering into SwiftUI views.\n\nHowever, the XML file does not contain any body text, so the 2nd step is to use the article url provided, and scrap the SMHS news website. This scraping feature still has lots of room for improvement, because the SMHS website structure is rather random for different news entries. Although the body content is usually contained in a specific <div>, the content inside this <div> can include text, images, videos, even tables. Thus when finding all text recursively in the <div>, the app HTML parser will sometimes get garbage text that is not part of the article, but instead image captions, website labels.etc.")
//                    Text("InClass™ View Computations")
//                        .font(.title2, weight: .bold)
//                        .padding(.top)
//                        .textAlign(.leading)

                }
                .font(.headline, weight: .medium)
                .foregroundColor(.platformSecondaryLabel)
                
            }
            .padding()
        }
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

struct HowStatementView_Previews: PreviewProvider {
    static var previews: some View {
        HowStatementView()
    }
}
