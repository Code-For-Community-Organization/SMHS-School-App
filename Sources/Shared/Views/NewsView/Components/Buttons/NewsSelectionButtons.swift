//
//  NewsSelectionButtons.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftUI

struct NewsSelectionButtons: View {
    @ObservedObject var newsViewViewModel: NewsViewViewModel
    @Binding var selected: NewsCategories
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                HorizontalLabelButton(label: "Campus Stories", symbol: .squareGrid3x2Fill, tag: .general, selected: $selected)
                    .onTapGesture {
                        selected = .general
                    }
                HorizontalLabelButton(label: "Bookmarked", symbol: .bookmarkFill, tag: .bookmarked, selected: $selected)
                    .onTapGesture {
                        selected = .bookmarked
                    }
                HorizontalLabelButton(label: "Art", tag: .art, selected: $selected)
                    .onTapGesture {
                        selected = .art
                        newsViewViewModel.fetchXML(for: .art)
                    }
            }
            .padding(.horizontal, 20)
   
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 25, trailing: 0))
        .edgesIgnoringSafeArea(.horizontal)
    }
}
