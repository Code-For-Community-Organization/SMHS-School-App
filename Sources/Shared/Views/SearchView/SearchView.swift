//
//  SearchView.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftlySearch
import SwiftUI

struct SearchView: View {
    @StateObject var newsViewViewModel = NewsViewViewModel()
    @State var searchText: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                if searchText.isEmpty {
                    InformationCardsView()
                        .aboutFooter(showDivider: false)
                } else {
                    SearchResultView(searchText: $searchText,
                                     newsEntries: newsViewViewModel.newsEntries,
                                     informationCards: InformationCard.informationCards)
                        .environmentObject(newsViewViewModel)
                }
            }
            .navigationBarSearch($searchText,
                                 placeholder: "Dates, News, SM Website, and More",
                                 hidesNavigationBarDuringPresentation: false,
                                 hidesSearchBarWhenScrolling: false,
                                 cancelClicked: {
                                     searchText = ""
                                 },
                                 searchClicked: {})
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
