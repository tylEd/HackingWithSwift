//
//  Petition.swift
//  Project7_WhitehousePetitions
//
//  Created by Tyler Edwards on 9/1/21.
//

import Foundation

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
