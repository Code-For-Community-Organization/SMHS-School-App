//
//  SearchResultView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftUI

struct SearchResultView: View {
    @Binding var searchText: String
    @StateObject var sharedScheduleInformation = SharedScheduleInformation()
    @State var newsEntries: [NewsEntry]
    @State var informationCards: [InformationCard]
    @State var informationCard: InformationCard?
    @EnvironmentObject var newsViewViewModel: NewsViewViewModel
    //MARK: - Search Results Filter
    var campusNewsResults: [NewsEntry] {
        newsEntries
                .filter{$0.title.lowercased()
                    .contains(searchText.lowercased()
                                .trimmingCharacters(in: .whitespacesAndNewlines))}
    }
    var body: some View {
        List {
            //if !searchText.isEmpty
            scheduleDays
            campusNews
            quickInformation
        }
        .listStyle(GroupedListStyle())
    }
    
    //MARK: - SwiftUI View Components
    var scheduleDays: some View {
        Section(header: Text("Schedule Days")) {
            ForEach(sharedScheduleInformation.scheduleWeeks
                        .mapAndFilter(searchText: searchText), id: \.self){day in
                NavigationLink(day.title, destination: ScheduleDetailView(scheduleDay: day))
            }
        }
    }
    
    var campusNews: some View {
        Section(header: Text("Campus News")) {
            ForEach(campusNewsResults, id: \.self){news in
                let bindingNews = Binding(get: {news}, set: {
                    guard let index = newsEntries.firstIndex(where: {$0.id == news.id}) else {return}
                    newsEntries[index] = $0
                     
                })
                NavigationLink(news.title,
                               destination: NewsDetailedView(newsEntry: bindingNews)
                                                .environmentObject(newsViewViewModel))
            }
        }
    }
    
    var quickInformation: some View {
        Section(header: Text("Quick Information")) {
            ForEach(informationCards
                        .filter{$0.title.lowercased()
                            .contains(searchText.lowercased()
                                        .trimmingCharacters(in: .whitespacesAndNewlines))}){card in
                Button(card.title) {
                    informationCard = card
                }
                .fullScreenCover(item: $informationCard) {
                    SafariView(url: $0.link).edgesIgnoringSafeArea(.all)
                }
            }
        }
    }
}

fileprivate extension Array where Element == ScheduleWeek {
    func mapAndFilter(searchText: String) -> [ScheduleDay] {
        self
            .flatMap({$0.scheduleDays})
            .filter{$0.title
                .lowercased()
                .contains(searchText.lowercased()
                            .trimmingCharacters(in: .whitespacesAndNewlines))}
    }
}
 
