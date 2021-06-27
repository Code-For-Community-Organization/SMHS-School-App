//
//  NewsViewViewModel.swift
//  SMHSSchedule
//
//  Created by Jevon Mao on 5/10/21.
//

import Foundation
import Combine
import SwiftyXMLParser
import SwiftSoup

final class NewsViewViewModel: ObservableObject {
    private var cancellable: AnyCancellable?
    @Published(key: "bookmarkedEntries") var bookMarkedEntries = [NewsEntry]()
    @Published(key: "newsEntries") var newsEntries = [NewsEntry]()
    @Published var isLoading: Bool = true
    init(newsEntries: [NewsEntry]? = nil) {
        fetchXML()
    } 
    
    private func fetchXML() {
        let url = URL(string: "https://www.smhs.org/fs/post-manager/boards/37/posts/feed")!
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .retry(2)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {_ in}){data, response in
                guard let rawText = String(data: data, encoding: .utf8) else {return}
                self.newsEntries = self.parseXML(for: rawText)
            }

    }
    
    private func parseXML(for rawText: String) -> [NewsEntry] {
        do {
            let xml = try XML.parse(rawText)
            var newsEntries = [NewsEntry]()
            for feed in xml["feed", "entry"] {
                guard let title = feed["title"].text,
                      let author = feed["author", "name"].text?.trimmingCharacters(in: .whitespacesAndNewlines),
                      let image = parseHTMLImgTag(for: feed["content"].text ?? ""),
                      let articleURL = URL(string: feed["link"].attributes["href"] ?? "") else {continue}
                newsEntries.append(.init(title: title, author: author, imageURL: image, articleURL: articleURL))
            }
            return newsEntries
        }
        catch {
            #if DEBUG
            print("Parse XML failed with error: \(error)")
            #endif
            return []
        }
   
    }
    
    private func parseHTMLImgTag(for html: String) -> URL? {
        do {
            let parsed = try SwiftSoup.parse(html)
            let img = try parsed.select("img").first()
            let urlString = try img?.attr("src")
            return URL(string: urlString ?? "")
        }
        catch Exception.Error(let type, Message: let message) {
            #if DEBUG
            print("Error of type \(type), \(message)")
            #endif
        }
        catch {
            print(error)
        }
        return nil
    }
    
    private func toggleEntryBookmarked(_ entry: NewsEntry) {
        if bookMarkedEntries.contains(where: {$0.id == entry.id}) {
            bookMarkedEntries = bookMarkedEntries.filter{$0.id != entry.id}
        }
        else {
            bookMarkedEntries.append(entry)
        }
    }
}

extension NewsViewViewModel {
    static let sampleNewsViewViewModel = NewsViewViewModel(newsEntries: [.init(title: "Acclaimed Professors Teach Virtual Master Classes",
                                                                               author: "Elizabeth Bottiaux",
                                                                               imageURL: URL(string: "https://resources.finalsite.net/images/f_auto,q_auto,t_image_size_4/v1620330979/smhsorg/xxqwckx8sjfkrd1iymoa/StudentSoloistsandLiamTeagueApril2021.jpg")!,
                                                                               articleURL: URL(string: "https://www.smhs.org/about/news/news-stories-details/~board/all-news/post/acclaimed-professors-teach-virtual-master-classes")!)])
}
