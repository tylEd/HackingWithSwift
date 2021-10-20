//
//  Prospect.swift
//  Project16_HotProspects
//
//  Created by Tyler Edwards on 10/20/21.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    var id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    
    static let saveFile = "SavedData"
    
    init() {
        self.people = []
        loadData()
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
        saveData()
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        saveData()
    }
    
    func getDocsDir() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadData() {
        let fileName = getDocsDir().appendingPathComponent(Self.saveFile)
        
        do {
            let data = try Data(contentsOf: fileName)
            people = try JSONDecoder().decode([Prospect].self, from: data)
        } catch {
            print("Unable to load saved data.")
            print(error)
        }
    }
    
    private func saveData() {
        let fileName = getDocsDir().appendingPathComponent(Self.saveFile)
        
        do {
            let data = try JSONEncoder().encode(people)
            try data.write(to: fileName, options: [.atomicWrite, .completeFileProtection])
        } catch {
            print("Unable to save data.")
            print(error)
        }
    }
}
