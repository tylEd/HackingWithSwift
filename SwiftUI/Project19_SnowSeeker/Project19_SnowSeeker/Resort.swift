//
//  Resort.swift
//  Project19_SnowSeeker
//
//  Created by Tyler Edwards on 10/23/21.
//

import Foundation


struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
    
    static let allCountries = Set(Resort.allResorts.map { $0.country }).sorted()
    static let allSizes = Set(Resort.allResorts.map { $0.size }).sorted()
    static let allPrices = Set(Resort.allResorts.map { $0.price }).sorted()
}
