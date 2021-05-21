//
//  SearchResultView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftUI

struct SearchResultView: View {
    @Binding var searchText: String
    @State var scheduleWeeks: [ScheduleWeek]
    @State var newsEntries: [NewsEntry]
    @State var informationCards: [InformationCard]
    @State var informationCard: InformationCard?
    var body: some View {
        List {
            Section(header: Text("Schedule Days")) {
                ForEach(scheduleWeeks
                            .flatMap({$0.scheduleDays})
                            .filter{$0.title
                                .lowercased()
                                .contains(searchText.lowercased()
                                            .trimmingCharacters(in: .whitespacesAndNewlines))}, id: \.self){day in
                    NavigationLink(day.title, destination: ScheduleDetailView(scheduleDay: day))
                }
            }
            Section(header: Text("Campus News")) {
                ForEach(newsEntries
                            .filter{$0.title.lowercased()
                                .contains(searchText.lowercased()
                                            .trimmingCharacters(in: .whitespacesAndNewlines))}, id: \.self){news in
                    let bindingNews = Binding(get: {news}, set: {
                        guard let index = newsEntries.firstIndex(where: {$0.id == news.id}) else {return}
                        newsEntries[index] = $0
                        
                    })
                    NavigationLink(news.title, destination: NewsDetailedView(newsEntry: bindingNews))
                }
            }
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
        .listStyle(GroupedListStyle())
    }
}

