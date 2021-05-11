//
//  NewsDetailedView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import SwiftUI
import Kingfisher

struct NewsDetailedView: View {
    @Binding var newsEntry: NewsEntry
    var body: some View {
        ScrollView {
            VStack {
                KFImage(newsEntry.imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIScreen.screenWidth)
                    .frame(maxHeight: 400)
                    .clipped()
                Group {
                    Text(newsEntry.title)
                        .font(.system(.title, design: .serif))
                        .fontWeight(.black)
                        .textAlign(.leading)
                        .padding(.top, -3)
                    Text("BY \(newsEntry.author)")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .textAlign(.leading)
                        .textCase(.uppercase)
                        .foregroundColor(.platformSecondaryLabel)
                        .padding(.top, 1)
                        .padding(.bottom, 20)

                    if let text = newsEntry.bodyText {
                        Text(text)
                            .font(.system(.body, design: .serif))
                            .fontWeight(.light)
                    }
                    else {
                        Text(NewsEntry.sampleEntry.bodyText!)
                            .redacted(reason: .placeholder)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 10, trailing: 30))
                Spacer()

            }
            .padding(.top, 20)
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
           newsEntry.loadBodyText{newsEntry.bodyText = $0}
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct NewsDetailedView_Previews: PreviewProvider {
    static var previews: some View {
        NewsDetailedView(newsEntry: .constant(.sampleEntry))
    }
}
