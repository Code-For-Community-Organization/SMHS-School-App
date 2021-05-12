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
                    .padding(.top, 35)
                    ForEach(newsViewViewModel.newsEntries, id:\.self){
                        NewsEntryListItem(newsEntry: $0)
                    }
                    .padding(.top, 10)

                }
                .padding(.horizontal)
            }
            .navigationBarTitle(scheduleViewModel.dateHelper.currentDate)

        }
        .onAppear{
            newsViewViewModel.fetchXML()
        }
        .navigationBarTitleDisplayMode(.automatic)
    }
}

struct NewsView_Previews: PreviewProvider {
    static var previews: some View {
        NewsView(scheduleViewModel: ScheduleViewModel())
    }
}
