//
//  NewsView.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import SwiftUI
import Kingfisher 

struct NewsView: View {
    var todayDateDescription: String {ScheduleDateHelper().todayDateDescription}
    @StateObject var newsViewViewModel = NewsViewViewModel()
    @EnvironmentObject var userSettings: UserSettings
    @State var selection = NewsCategories.general
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack {
                    NewsSelectionButtons(newsViewViewModel: newsViewViewModel,
                                         selected: $selection)
                    LazyVStack {
                        subHeader
                        switch selection {
                        case .general:
                            ForEach(newsViewViewModel.newsEntries, id:\.self){
                                NewsEntryListItem(newsEntry: $0)
                                    .environmentObject(newsViewViewModel)
                            }
                        case .art:
                            ForEach(newsViewViewModel.artEntries, id:\.self){
                                NewsEntryListItem(newsEntry: $0)
                                    .environmentObject(newsViewViewModel)
                            }
                        case .bookmarked:
                            ForEach(newsViewViewModel.bookMarkedEntries, id:\.self){
                                NewsEntryListItem(newsEntry: $0)
                                    .environmentObject(newsViewViewModel)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

            }
            .navigationBarTitle(todayDateDescription)
            .aboutFooter()

        }
        .navigationBarTitleDisplayMode(.automatic)
        .navigationViewStyle() 
    }
    
    var subHeaderText: String {
        switch selection {
        case .general:
            return "Top Stories"
        case .art:
            return "Arts Stories"
        case .bookmarked:
            return "Your Stories"
        }
    }
    var subHeader: some View {
        VStack {
            Text("Campus News")
                .fontWeight(.semibold)
                .font(.caption)
                .foregroundColor(Color.platformSecondaryLabel)
                .textCase(.uppercase)
                .textAlign(.leading)
            Text(subHeaderText)
                .fontWeight(.black)
                .font(.title)
                .foregroundColor(.primary)
                .textAlign(.leading)
        }
        .padding(EdgeInsets(top: 35, leading: 3, bottom: 10, trailing: 3))

    }
}

fileprivate extension View {
    
    @ViewBuilder
    func navigationViewStyle() -> some View {
        if UIScreen.idiom == .pad {
            self.navigationViewStyle(DefaultNavigationViewStyle())
        }
        else {
            self.navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
