//
//  NewsSelectionButtons.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftUI

struct NewsSelectionButtons: View {
    @Binding var selected: Int
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                HorizontalLabelButton(label: "All Stories", symbol: .squareGrid3x2Fill, tag: 1, selected: $selected)
                    .onTapGesture {
                        selected = 1
                    }
                HorizontalLabelButton(label: "Bookmarked", symbol: .bookmarkFill, tag: 2, selected: $selected)
                    .onTapGesture {
                        selected = 2
                    }
                HorizontalLabelButton(label: "Sports", tag: 3, selected: $selected)
                    .onTapGesture {
                        selected = 3
                    }
                HorizontalLabelButton(label: "Arts", tag: 4, selected: $selected)
                    .onTapGesture {
                        selected = 4
                    }
            }
            .padding(.horizontal, 20)
   
        }
        .padding(EdgeInsets(top: 10, leading: 0, bottom: 25, trailing: 0))
        .edgesIgnoringSafeArea(.horizontal)
    }
}

struct NewsSelectionButtons_Previews: PreviewProvider {
    static var previews: some View {
        NewsSelectionButtons(selected: .constant(1))
    }
}
