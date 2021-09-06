//
//  AnnoucementResponse.swift
//  SMHSSchedule (macOS)
//
//  Created by Jevon Mao on 9/3/21.
//

import Foundation

struct AnnoucementResponse: Codable, Hashable {
    var fullHtml: String
    var date: String

    func getIncreasedFontSizeHTML() -> String {
        let tag = #"<font size="+5">"#
        return tag + fullHtml
    }
}
