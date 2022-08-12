//
//  Banner.swift
//  SMHS (iOS)
//
//  Created by Lampeh on 7.08.2022.
//

import Foundation
import SwiftUI
import FirebaseDatabase

struct Banner: Identifiable, Codable, Equatable {
    let headline: String
    let title: String
    let footnote: String
    
    let image: URL
    
    let paragraphs: [String]
    
    let requirements: [Requirement]
    
    enum Requirement: String, Codable {
        case name, phoneNumber, email, school, grade
    }
    
    let email: String
    
    var id: String { title }
    
    static func fetch() async throws -> [Banner] {
        let db = Database.database().reference()
        
        let snapshot = try await db.getData()
        
        let data = try JSONSerialization.data(withJSONObject: snapshot.value as Any)
        
        let banners = try JSONDecoder().decode([Banner].self, from: data)
        
        return banners
    }
    
    func submit(name: String? = nil, phoneNumber: String? = nil, email: String? = nil, school: String? = nil, grade: String? = nil) async throws {
        print("Submitted form data.")
        let url = URL(string: "http://127.0.0.1:5000/submit")! // TODO
        
        var request = URLRequest(url: url)
        
        let body = try JSONSerialization.data(withJSONObject: [
            "name": name,
            "phone_number": phoneNumber,
            "email": email,
            "school": school,
            "grade": grade,
            "send_email": self.email,
        ])
        
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        
        #if DEBUG
        let db = Database.database().reference()
        
        let ref = db.child("0/submissions").childByAutoId()
        
        try await ref.setValue([
            "name": name,
            "phone_number": phoneNumber,
            "email": email,
            "school": school,
            "grade": grade
        ])
        #endif
        
        URLSession.shared.dataTask(with: request) { data, res, error in
            let ok = (200...300).contains((res as? HTTPURLResponse)?.statusCode ?? 0)
            
            if ok {
                print("Successfully sent email.")
                
                let db = Database.database().reference()
                
                let ref = db.child("0-submissions").childByAutoId()
                
                ref.setValue([
                    "name": name,
                    "phone_number": phoneNumber,
                    "email": email,
                    "school": school,
                    "grade": grade
                ])
            }
        }
    }
}
