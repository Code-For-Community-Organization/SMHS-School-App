//
//  NewsView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import SwiftUI
import Kingfisher

struct NewsView: View {
    @StateObject var newsViewViewModel = NewsViewViewModel()
    @StateObject var scheduleViewModel: ScheduleViewModel
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    VStack {
                        Text("CAMPUS NEWS")
                            .fontWeight(.semibold)
                            .font(.caption)
                            .foregroundColor(Color.platformSecondaryLabel)
                            .textAlign(.leading)
                        
                        Text("Top Stories")
                            .fontWeight(.black)
                            .font(.title)
                            .foregroundColor(.primary)
                            .textAlign(.leading)
                    }
                    .padding(.horizontal, 3)
                    .padding(.top, 25)
                    ForEach(newsViewViewModel.newsEntries, id:\.self){newsEntry in
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
                            Spacer()
                            KFImage(newsEntry.imageURL)
                                .placeholder {
                                    Color(UIColor.systemGray)
                                }
                                .onSuccess{_ in
                                    print("SUCCESS!")
                                }
                                .retry(maxCount: 3, interval: .seconds(3))
                                .onFailure {
                                    #if DEBUG
                                        print("failure: \($0)")
                                    #endif
                                    }
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(RoundedRectangle(cornerRadius: 7, style: .continuous))
                        }
                        .padding()
                        .background(Color.platformSecondaryBackground)
                        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
                    }
                    .padding(.top, 15)

                }
                .padding(.horizontal)
            }
            .navigationBarTitle(scheduleViewModel.dateHelper.currentDate)

        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(scheduleViewModel: ScheduleViewModel())
    }
}
