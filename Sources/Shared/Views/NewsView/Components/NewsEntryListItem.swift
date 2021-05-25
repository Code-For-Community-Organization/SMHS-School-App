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
    @EnvironmentObject var newsViewViewModel: NewsViewViewModel
    let downsampler = DownsamplingImageProcessor(size: .init(width: 230, height: 230))
    var body: some View {
        ZStack {
            NavigationLink(destination: NewsDetailedView(newsEntry: $newsEntry).environmentObject(newsViewViewModel), isActive: $isActive, label: {EmptyView()})
            Button(action: {isActive = true}) {
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
            }

        }
        .contextMenu {
            if newsViewViewModel.bookMarkedEntries.contains(where: {$0.id == newsEntry.id}) {
                Button("Unbookmark", systemImage: .bookmarkFill) {
                    newsViewViewModel.toggleEntryBookmarked(newsEntry)
                }
            }
            else {
                Button("Bookmark", systemImage: .bookmark) {
                    newsViewViewModel.toggleEntryBookmarked(newsEntry)
                }
            }
        }
        .padding(.vertical, 10)
 
    }
}

struct NewsEntryListItem_Previews: PreviewProvider {
    static var previews: some View {
        NewsEntryListItem(newsEntry: .sampleEntry)
    }
}
