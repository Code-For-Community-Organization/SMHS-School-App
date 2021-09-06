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
    var lineLimit: Int = 1
    static let informationCards = [InformationCard(title: "Eagle Eats", backgroundColor: Color.systemPink, link: URL(string: "https://www.smhs.org/campus-life/dining")!, image: Image("food")),
                                   InformationCard(title: "SMHS Homepage", backgroundColor: Color.systemRed, link: URL(string: "https://www.smhs.org/")!, image: Image("SMHS-Aerial"), lineLimit: 2),
                                   InformationCard(title: "Athletics", backgroundColor: Color.systemTeal, link: URL(string: "https://www.smhs.org/athletics")!, image: Image("Athletics")),
                                   InformationCard(title: "Directory", backgroundColor: Color.systemGreen, link: URL(string: "https://www.smhs.org/about/facultystaff")!, image: Image("SM-Field")),
                                   InformationCard(title: "Master Calendar", backgroundColor: Color.systemBlue, link: URL(string: "https://www.smhs.org/cal")!, image: Image("Campus_life"), lineLimit: 2),
                                   InformationCard(title: "COVID-19", backgroundColor: Color.appPrimary, link: URL(string: "https://www.smhs.org/other/update-center")!, image: Image(uiImage: #imageLiteral(resourceName: "COVID-19"))),
                                   InformationCard(title: "Speak Up!", backgroundColor: Color.appSecondary, link: URL(string: "https://www.smhs.org/other/speak-up")!, image: Image(uiImage: #imageLiteral(resourceName: "Speakup"))),
                                   InformationCard(title: "School Calendar", backgroundColor: Color.systemPurple, link: URL(string: "https://www.smhs.org/other/full-school-calendar")!, image: Image(uiImage: #imageLiteral(resourceName: "Calendar")), lineLimit: 2),
                                   InformationCard(title: "Bell Schedule", backgroundColor: Color.systemTeal, link: URL(string: "https://www.smhs.org/other/parents/virtual-bell-schedule")!, image: Image(uiImage: #imageLiteral(resourceName: "Office-box"))),
                                   InformationCard(title: "ETV 2.0", backgroundColor: Color.systemYellow, link: URL(string: "https://www.youtube.com/c/EAGLETV20/videos")!, image: Image(uiImage: #imageLiteral(resourceName: "Broadcast"))),
                                   InformationCard(title: "Announcements", backgroundColor: Color.systemOrange, link: URL(string: "https://www.smhs.org/other/parents/etv-announcements")!, image: Image(uiImage: #imageLiteral(resourceName: "Megaphone")))]
}
