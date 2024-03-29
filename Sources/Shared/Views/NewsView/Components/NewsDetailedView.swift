//
//  NewsDetailedView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import SwiftUI
import Kingfisher

struct NewsDetailedView: View {
    @EnvironmentObject var newsViewViewModel: NewsViewViewModel
    @Binding var newsEntry: NewsEntry
    let scheduleDateHelper = ScheduleDateHelper()
    let imageHeight = UIScreen.screenHeight/CGFloat(2)
    var body: some View {
        GeometryReader {geo in
                ScrollView {
                    VStack {
                        if UIScreen.idiom == .pad {
                            KFImage(newsEntry.imageURL)
                                .resizable()
                                .scaledToFill()
                                .frame(width: geo.size.width)
                                .frame(maxHeight: imageHeight)
                                .clipped()
                        }
                        else {
                            KFImage(newsEntry.imageURL)
                                .resizable()
                                .scaledToFill()
                                //.frame(width: UIScreen.screenWidth)
                                //.frame(maxHeight: imageHeight)
                                .clipped()
                                //.ignoresSafeArea()
                        }
                        Group {
                            Text(newsEntry.title)
                                .font(.system(.title, design: .default))
                                .fontWeight(.bold)
                                .textAlign(.leading)
                                .padding(.top, -1)
                            Text("By \(newsEntry.author)")
                                .font(.subheadline)
                                .fontWeight(.medium)
                                .textAlign(.leading)
                                .foregroundColor(.platformSecondaryLabel)
                                .padding(.top, 1)
                                .padding(.bottom, 20)

                            if let text = newsEntry.bodyText {
                                Text(text)
                                    .font(.system(.headline, design: .serif))
                                    .fontWeight(.light)
                                    .lineLimit(nil)

                            }
                            else {
                                Text(NewsEntry.sampleEntry.bodyText!)
                                    .redacted(reason: .placeholder)
                            }
                        }
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 10, trailing: 30))
                        .frame(maxWidth: 600)
                        Spacer()

                    }

            }
                .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            var entry = newsEntry
            newsEntry.loadBodyText{entry.bodyText = $0; newsEntry.bodyText = $0}
            newsEntry = entry
        }
        .navigationBarItems(trailing: NewsNavigationBarButtons(newsEntry: newsEntry).environmentObject(newsViewViewModel))
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NewsDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailedView(newsEntry: .constant(.sampleEntry))
            .environmentObject(NewsViewViewModel())

        NavigationView {
            NavigationLink("Detail") {
                NewsDetailedView(newsEntry: .constant(.sampleEntry))
                    .environmentObject(NewsViewViewModel())
            }
        }

    }
}
