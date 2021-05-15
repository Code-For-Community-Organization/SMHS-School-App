//
//  NewsSelectionButtons.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import SwiftUI

struct NewsSelectionButtons: View {
    @State var selected = 1
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
            }
   
        }
        .padding(.top, 10)
        .padding(.bottom, 25)
        .edgesIgnoringSafeArea(.horizontal)
    }
}

struct NewsSelectionButtons_Previews: PreviewProvider {
    static var previews: some View {
        NewsSelectionButtons()
    }
}
