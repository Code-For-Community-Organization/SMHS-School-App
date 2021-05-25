//
//  SearchView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftUI
import SwiftUIX
import VisualEffects
import SwiftUIVisualEffects
import SwiftlySearch

struct SearchView: View {
    @StateObject var scheduleViewModel: ScheduleViewModel
    @StateObject var newsViewViewModel: NewsViewViewModel
    @State var searchText: String = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                if searchText.isEmpty {
                    InformationCardsView()
                        .aboutFooter(showDivider: false)
                }
                else {
                    SearchResultView(searchText: $searchText,
                                     scheduleWeeks: scheduleViewModel.scheduleWeeks,
                                     newsEntries: newsViewViewModel.newsEntries,
                                     informationCards: InformationCard.informationCards)
                }
            }
            .navigationBarSearch($searchText,
                                 placeholder: "Dates, News, SM Website, and More",
                                 hidesNavigationBarDuringPresentation: false,
                                 hidesSearchBarWhenScrolling: false,
                                 cancelClicked: {
                                    searchText = ""
                                 },
                                 searchClicked: {
                                    
                                 })
            

        }
        .navigationViewStyle(StackNavigationViewStyle())

        
        
    }
}

