//
//  NewsEntryListItem.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import SwiftUI
import Kingfisher

struct NewsEntryListItem: View {
    @State var newsEntry: NewsEntry
    @State var isActive: Bool = false
    let downsampler = DownsamplingImageProcessor(size: .init(width: 230, height: 230))
    var body: some View {
        ZStack {
            NavigationLink(destination: NewsDetailedView(newsEntry: $newsEntry)) {
                HStack {
                    VStack {
                        Text(newsEntry.author)
                            .font(.system(.caption, design: .serif))
                            .textAlign(.leading)
                            .padding(.bottom, 0.5)
                        Text(newsEntry.title)
                            .font(.system(.headline, design: .default))
                            .fontWeight(.black)
                            .multilineTextAlignment(.leading)
                            .textAlign(.leading)
                    }
                    .foregroundColor(Color.platformLabel)
                    Spacer()
                    
                    KFImage(newsEntry.imageURL)
                        .setProcessor(downsampler)
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
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
                }
                .padding(.vertical, 5)
            }
        }
        .navigationBarItems(trailing: HStack {
            Button(action: {}) {
                Image(systemSymbol: .heartFill)
            }
            Button(action: {}) {
                Image(systemSymbol: .bookmarkFill)
            }
        })
 
    }
}

struct NewsEntryListItem_Previews: PreviewProvider {
    static var previews: some View {
        NewsEntryListItem(newsEntry: .sampleEntry)
    }
}
