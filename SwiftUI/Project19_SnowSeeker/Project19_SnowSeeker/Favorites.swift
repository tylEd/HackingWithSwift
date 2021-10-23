//
//  Favorites.swift
//  Project19_SnowSeeker
//
//  Created by Tyler Edwards on 10/23/21.
//

import Foundation


class Favorites: ObservableObject {
    private var resorts: Set<String>
    
    private let saveKey = "Favorites"
    
    init() {
        // load our saved data
        if let data = UserDefaults.standard.data(forKey: saveKey) {
            if let loadedResorts = try? JSONDecoder().decode(Set<String>.self, from: data) {
                resorts = loadedResorts
                return
            }
        }
        
        self.resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    func add(_ resort: Resort) {
        objectWillChange.send()
        resorts.insert(resort.id)
        save()
    }
    
    func remove(_ resort: Resort) {
        objectWillChange.send()
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        // write out our data
        if let data = try? JSONEncoder().encode(resorts) {
            UserDefaults.standard.setValue(data, forKey: saveKey)
        }
    }
}
