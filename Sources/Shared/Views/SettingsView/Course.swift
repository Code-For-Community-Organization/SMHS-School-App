//
//  Course.swift
//  SMHS (iOS)
//
//  Created by Jevon Mao on 8/4/23.
//

import Foundation
import SwiftyJSON

struct Course: Codable, Equatable, Hashable, Identifiable {
    let title: String
    var id = UUID()
    static func getAll() -> [Course] {
        if let path = Bundle.main.path(forResource: Constants.coursesJsonPath, ofType: "json") {
            guard let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            else {
                preconditionFailure("Failed to decode Courses.json file")
            }
            let jsonResult = try! JSON(data: data)
            let allCourses = jsonResult["courses"].arrayValue
            let courses = allCourses
                .map{Course(title: $0["title"].stringValue)}
                .sorted {$0.title < $1.title}
            return courses
        }
        else {
            preconditionFailure("Cannot find file.")
        }
    }

}
