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
    @State var selection = 1
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    NewsSelectionButtons(selected: $selection)
                    LazyVStack {
                        VStack {
                            Text("Campus News")
                                .fontWeight(.semibold)
                                .font(.caption)
                                .foregroundColor(Color.platformSecondaryLabel)
                                .textCase(.uppercase)
                                .textAlign(.leading)
                            
                            Text(selection == 1 ? "Top Stories" : "Your Stories")
                                .fontWeight(.black)
                                .font(.title)
                                .foregroundColor(.primary)
                                .textAlign(.leading)
                        }
                        .padding(EdgeInsets(top: 35, leading: 3, bottom: 10, trailing: 3))
                        if selection == 1 {
                            ForEach(newsViewViewModel.newsEntries, id:\.self){
                                NewsEntryListItem(newsEntry: $0)
                                    .environmentObject(newsViewViewModel)
                            }
                        }
                        else {
                            ForEach(newsViewViewModel.bookMarkedEntries, id:\.self){
                                NewsEntryListItem(newsEntry: $0)
                                    .environmentObject(newsViewViewModel)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

            }
            .navigationBarTitle(scheduleViewModel.dateHelper.todayDateDescription)

        }
        .onAppear{
            newsViewViewModel.fetchXML()
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}
