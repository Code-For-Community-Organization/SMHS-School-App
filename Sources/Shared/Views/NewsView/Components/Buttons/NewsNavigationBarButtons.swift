//
//  NewsNavigationBarButtons.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/16/21.
//

import SwiftUI

struct NewsNavigationBarButtons: View {
    @EnvironmentObject var newsViewViewModel: NewsViewViewModel
    @State var newsEntry: NewsEntry
    @State var animate = false
    let animationDuration: Double = 0.1
    var isBookMarked: Bool {
        newsViewViewModel.bookMarkedEntries.contains{$0.id == newsEntry.id}
    }
    @State var showIsBookmarked = false
    var body: some View {
        HStack {
            Group {
                Button(action: handleButtonPress) {
                    Image(systemSymbol: showIsBookmarked ? .bookmarkFill : .bookmark)
                        .font(.system(size: 25))
                        .foregroundColor(showIsBookmarked ? appSecondary : .platformLabel)
                        .scaleEffect(animate ? CGFloat(1.1) : CGFloat(1))
                }
            }
            .animation(.spring())
        }
        .onAppear {
            showIsBookmarked = isBookMarked
        }
    }
}

extension NewsNavigationBarButtons {
    func handleButtonPress() {
        var hapticsManager = HapticsManager(impactStyle: .medium)
        newsViewViewModel.toggleEntryBookmarked(newsEntry)
        showIsBookmarked.toggle()
        hapticsManager.UIFeedbackImpact()
        animate = true
        DispatchQueue.main.asyncAfter(deadline: .now()+animationDuration) {
            animate = false
        }
    }
}
struct NewsNavigationBarButtons_Previews: PreviewProvider {
    static var previews: some View {
        NewsNavigationBarButtons(newsEntry: .sampleEntry)
    }
}
