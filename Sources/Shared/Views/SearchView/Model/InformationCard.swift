//
//  InformationCard.swift
//  SMHSSchedule (iOS)
//
//  Created by Jevon Mao on 5/14/21.
//

import Foundation
import SwiftUI

struct InformationCard: Identifiable {
    var id = UUID()
    var title: String
    var backgroundColor: Color
    var link: URL
    var image: Image
    static let informationCards = [InformationCard(title: "Eagle Eats", backgroundColor: Color.systemPink, link: URL(string: "https://www.smhs.org/campus-life/dining")!, image: Image("food")),
                                   InformationCard(title: "SMHS Homepage", backgroundColor: Color.systemRed, link: URL(string: "https://www.smhs.org/")!, image: Image("SMHS-Aerial")),
                                   InformationCard(title: "Athletics", backgroundColor: Color.systemTeal, link: URL(string: "https://www.smhs.org/athletics")!, image: Image("Athletics")),
                                   InformationCard(title: "Directory", backgroundColor: Color.systemGreen, link: URL(string: "https://www.smhs.org/about/facultystaff")!, image: Image("SM-Field")),
                                   InformationCard(title: "Master Calendar", backgroundColor: Color.systemBlue, link: URL(string: "https://www.smhs.org/cal")!, image: Image("Campus_life")),
                                   InformationCard(title: "COVID-19", backgroundColor: Color.primary, link: URL(string: "https://www.smhs.org/other/update-center")!, image: Image(uiImage: #imageLiteral(resourceName: "COVID-19")))]
}