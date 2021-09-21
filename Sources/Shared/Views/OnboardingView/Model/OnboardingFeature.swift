//
//  OnboardingFeature.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 9/20/21.
//

import Foundation
import SwiftUI

struct OnboardingFeature: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var symbolImage: Image
    var linkTitle: String?
    var linkURL: String?

    static let sampleFeature: OnboardingFeature! = newVersionFeatures.first
    static let newVersionFeatures: [OnboardingFeature] = [
        .init(title: "Join Our Teams!",
              description: "The SMHS app's Teams forum is now available for SMCHS students, using your school email.",
              symbolImage: Image(systemSymbol: .bubbleLeftFill)),
        .init(title: "Period 8",
              description: "Optionally turned off period 8 in settings.",
              symbolImage: Image(systemSymbol: ._8SquareFill)),
        .init(title: "Open Source",
              description: "SMHS Schedule is fully open source, contributions are welcome on Github.",
              symbolImage: Image(systemSymbol: .chevronLeftSlashChevronRight),
              linkTitle: "Learn more.",
              linkURL: "https://github.com/jevonmao/SMHS-Schedule")
    ]
}
