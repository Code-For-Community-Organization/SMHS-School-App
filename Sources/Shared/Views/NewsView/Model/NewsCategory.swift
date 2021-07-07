//
//  NewsCategory.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 7/7/21.
//

import Foundation

struct NewsCategory {
    var category: NewsCategories
    
    //Special ID in the URL for fetching XML
    //of different categories of news
    var id: Int {
        switch category {
        case .bookmarked:
            return 37
        case .general:
            return 37
        case .art:
            return 82
        }
    }
    
    static let general = NewsCategory(category: .general)
    static let art = NewsCategory(category: .art)
}

enum NewsCategories {
    case general, art, bookmarked
    
}
