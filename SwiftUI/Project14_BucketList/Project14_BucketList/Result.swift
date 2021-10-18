//
//  Result.swift
//  Project14_BucketList
//
//  Created by Tyler Edwards on 10/18/21.
//

import Foundation

struct Result: Codable {
    let query: Query
}

struct Query: Codable {
    let pages: [Int: Page]
}

struct Page: Codable, Comparable {
    let pageid: Int
    let title: String
    let terms: [String: [String]]?
    
    var desc: String {
        terms?["description"]?.first ?? "No further info"
    }
    
    static func < (lhs: Page, rhs: Page) -> Bool {
        lhs.title < rhs.title
    }
}
