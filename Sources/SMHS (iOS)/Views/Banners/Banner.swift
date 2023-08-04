//
//  Banner.swift
//  SMHS (iOS)
//
//  Created by Lampeh on 7.08.2022.
//

import Foundation
import SwiftUI
import FirebaseDatabase
import Alamofire

struct Banner: Identifiable, Codable, Equatable {
    let headline: String
    let title: String
    let footnote: String
    let externalLink: URL
    let image: URL
    let isActive: Bool
    let paragraphs: [String]
    
    let requirements: [Requirement]
    
    enum Requirement: String, Codable {
        case name, phoneNumber, email, school, grade
    }
    
    let email: String
    
    let id = UUID()
    
    static func fetch() async throws -> [Banner] {
        let db = Database.database().reference()
        
        let snapshot = try await db.getData()
        
        let data = try JSONSerialization.data(withJSONObject: snapshot.value as Any)
        
        let banners = try JSONDecoder().decode([Banner].self, from: data).filter{$0.isActive}
        
        return banners
    }
    
    func submit(name: String, phoneNumber: String, email: String, school: String, grade: String) async throws {
        let endpoint = Endpoint.submit(name: name, phoneNumber: phoneNumber, email: email, school: school, grade: grade, sendEmail: self.email)
        
        AF.request(endpoint.request)
            .response(completionHandler: { result in
                let res = result.response
                
                let ok = (200...300).contains(res?.statusCode ?? 0)
                
                if ok {
                    print("Successfully sent email.")
                    
                    Task {
                        let db = Database.database().reference()
                        guard let data = try? await db.getData() else { return }
                        
                        let index = Array(data.children).firstIndex { child in
                            let snapshot = child as! DataSnapshot
                            
                            let dict = snapshot.value as! [String: Any]
                            
                            return dict["title"] as? String == title
                        }
                        
                        guard let index = index else { return }
                        
                        let ref = db.child("\(index)/submissions").childByAutoId()
                        
                        try await ref.setValue([
                            "name": name,
                            "phone_number": phoneNumber,
                            "email": email,
                            "school": school,
                            "grade": grade
                        ])
                    }
                }
            })
            .resume()
        }
}
