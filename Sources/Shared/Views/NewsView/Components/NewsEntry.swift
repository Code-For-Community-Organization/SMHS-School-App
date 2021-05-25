//
//  NewsEntry.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import Foundation
import SwiftSoup
import Combine
import SwiftyXMLParser

struct NewsEntry: Hashable, Codable {
    init(title: String, author: String, imageURL: URL, articleURL: URL, bodyText: String? = nil) {
        self.title = title
        self.author = author
        self.imageURL = imageURL
        self.articleURL = articleURL
        self.bodyText = bodyText
    }
    var id = UUID()
    var title: String
    var author: String
    var imageURL: URL
    var articleURL: URL
    var bodyText: String? = ""
    
    func loadBodyText(completion: @escaping (String?) -> Void) {
        Downloader.load(articleURL.absoluteString){data, error in 
            guard let data = data, error == nil else {print(error!); return}
            let html = String(data: data, encoding: .ascii)
            completion(parseHTMLBodyText(html: html ?? ""))
        }
    }
    
    func parseHTMLBodyText(html: String) -> String? {
        do {
            let html = try SwiftSoup.parse(html)
            let bodyDiv = try html.select("div.fsBody").first()
            let bodyDivText = try bodyDiv?.text()
            let paragraphs = try bodyDiv?.children()
                                .filter{$0.tagName() == "p"}
                                .map{try $0.text()}
                                .filter{$0.count > 3}
            if let paragraphs = paragraphs, paragraphs != [] {return paragraphs.joined(separator: "\n\n\n")} else {
                return bodyDivText
            }
        }
        catch Exception.Error(let type, let message) {
            #if DEBUG
            print("Error: \(type), message: \(message)")
            #endif
        }
        catch {
            #if DEBUG
            print("Some error occured")
            #endif
        }
        return nil
    }
    
    static let sampleEntry = NewsEntry(title: "Acclaimed Professors Teach Virtual Master Classes",
                                       author: "Elizabeth Bottiaux",
                                       imageURL: URL(string: "https://resources.finalsite.net/images/f_auto,q_auto,t_image_size_4/v1620330979/smhsorg/xxqwckx8sjfkrd1iymoa/StudentSoloistsandLiamTeagueApril2021.jpg")!,
                                       articleURL: URL(string: "https://www.smhs.org/about/news/news-stories-details/~board/all-news/post/acclaimed-professors-teach-virtual-master-classes")!,
                                       bodyText: """
SMCHS students had the unique opportunity to participate in virtual masterclasses with renowned professors. Hailed as the Paganini of the steel drum, Professor Liam Teague is the Professor of Music and Head of Steelpan Studies at Northern Illinois University and a former college professor of Ms. Duncan, percussion teacher. Professor Jamie Whitmarsh is a composer, conductor and percussionist. He is composition faculty at Oklahoma City University and Principal Timpanist of the Oklahoma City Philharmonic.
        
Teague worked with a steel drums class on a piece he wrote. The piece will be performed at the Nick Kraus Memorial Scholarship Concert on Sunday, May 23 at 7:00 p.m. in the Moiso Family Pavillion. Teague also worked with four student soloists, Lizzie Dilao '21, Allie Sadoff '22, Emily Horn '21 and Raj Pai '22. Professor Teague and Professor Whitmarsh worked with the symphony orchestra. Dr. Clarino, Instrumental Music Teacher and Band Director, conducted the orchestra while Ms. Duncan was the soloist.

Both professors worked with the students on musicality and technique while providing invaluable feedback.

"It was such a pleasure being able to work with these students. I am deeply passionate about the national instrument of Trinidad and Tobago - the steelpan - and having these types of opportunities to speak to these young ambassadors is so important,” said Teague.
""")
}
