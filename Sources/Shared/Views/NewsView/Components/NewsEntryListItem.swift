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
                VStack {
                    HStack {
                        authorAndTitle
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
                            .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    Spacer()
                    ZStack(alignment: .top) {
                        appSecondary
                            .frame(height: 20)
                        Divider()
                    }
                }
                
            }
        }
        .background(Color.platformBackground)
        .contextMenu(menuItems: {
            if newsViewViewModel.bookMarkedEntries.contains(where: {$0.id == newsEntry.id}) {
                Button(action: {
                    newsViewViewModel.toggleEntryBookmarked(newsEntry)
                }) {
                    Label("Unbookmark", systemSymbol: .bookmarkSlash)
                }
            }
            else {
                Button(action: {
                    newsViewViewModel.toggleEntryBookmarked(newsEntry)
                }) {
                    Label("Bookmark", systemSymbol: .bookmark)
                }
            }
        })
        .roundedCorners(cornerRadius: 10)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 2.5, y: 5)
        .padding(.vertical, 10)

    }
        var authorAndTitle: some View {
            VStack {
                Text(newsEntry.author)
                    .font(.system(.footnote, design: .serif))
                    .textAlign(.leading)
                    .padding(.bottom, 0.5)
                Text(newsEntry.title)
                    .font(.system(.headline, design: .default))
                    .fontWeight(.heavy)
                    .multilineTextAlignment(.leading)
                    .textAlign(.leading)
                Spacer()
            }
            .foregroundColor(Color.platformLabel)
        }
    
}

struct NewsEntryListItem_Previews: PreviewProvider {
    static var previews: some View {
        NewsEntryListItem(newsEntry: .sampleEntry)
    }
}
