//
//  Filters.swift
//  Project19_SnowSeeker
//
//  Created by Tyler Edwards on 10/23/21.
//

import Foundation


struct Filters {
    var countries = Set<String>()
    var sizes = Set<Int>()
    var prices = Set<Int>()
    
    func contains(resort: Resort) -> Bool {
        return (countries.isEmpty || countries.contains(resort.country)) &&
            (sizes.isEmpty || sizes.contains(resort.size)) &&
            (prices.isEmpty || prices.contains(resort.price))
    }
    
    mutating func clear() {
        countries.removeAll()
        sizes.removeAll()
        prices.removeAll()
    }
    
    mutating func toggle(country: String) {
        if countries.contains(country) {
            countries.remove(country)
        } else {
            countries.insert(country)
        }
    }
    
    mutating func toggle(size: Int) {
        if sizes.contains(size) {
            sizes.remove(size)
        } else {
            sizes.insert(size)
        }
    }
    
    mutating func toggle(price: Int) {
        if prices.contains(price) {
            prices.remove(price)
        } else {
            prices.insert(price)
        }
    }
}
