//
//  NewsView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import SwiftUI
import Kingfisher 

struct NewsView: View {
    @StateObject var newsViewViewModel: NewsViewViewModel
    @StateObject var scheduleViewModel: ScheduleViewModel
    @EnvironmentObject var userSettings: UserSettings
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    VStack {
                        Text("Campus News")
                            .fontWeight(.semibold)
                            .font(.caption)
                            .foregroundColor(Color.platformSecondaryLabel)
                            .textCase(.uppercase)
                            .textAlign(.leading) 
                        
                        Text("Top Stories")
                            .fontWeight(.black)
                            .font(.title)
                            .foregroundColor(.primary)
                            .textAlign(.leading)
                    }
                    .padding(.horizontal, 3)
                    .padding(.top, 35)
                    ForEach(newsViewViewModel.newsEntries, id:\.self){
                        NewsEntryListItem(newsEntry: $0)
                    }
                    .padding(.top, 10)

                }
                .padding(.horizontal)
            }
            .navigationBarTitle(scheduleViewModel.dateHelper.todayDateDescription)

        }
        .onAppear{
            newsViewViewModel.fetchXML()
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}
