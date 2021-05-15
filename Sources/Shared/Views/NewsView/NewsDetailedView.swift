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
    let scheduleDateHelper = ScheduleDateHelper()
    var body: some View {
        GeometryReader {geo in
                ScrollView {
                VStack {
                    if UIScreen.idiom == .pad {
                        KFImage(newsEntry.imageURL)
                            .resizable()
                            .scaledToFill()
                            .frame(width: geo.size.width)
                            .frame(maxHeight: UIScreen.screenHeight/CGFloat(2))
                            .clipped()
                    }
                    else {
                        KFImage(newsEntry.imageURL)
                            .resizable()
                            .scaledToFill()
                            .frame(width: UIScreen.screenWidth)
                            .frame(maxHeight: UIScreen.screenHeight/CGFloat(2))
                            .clipped()
                    }

                    Group {
                        Text(newsEntry.title)
                            .font(.system(.title, design: .serif))
                            .fontWeight(.black)
                            .textAlign(.leading)
                            .padding(.top, -1)
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
                .padding(.top, 20)
                
            }
            
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
