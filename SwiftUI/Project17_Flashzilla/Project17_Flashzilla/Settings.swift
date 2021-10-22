//
//  Settings.swift
//  Project17_Flashzilla
//
//  Created by Tyler Edwards on 10/21/21.
//

import Foundation

class Settings: ObservableObject {
    static let retryKey = "Retry"

    @Published var retry: Bool = UserDefaults.standard.bool(forKey: Settings.retryKey) {
        willSet {
            UserDefaults.standard.setValue(newValue, forKey: Settings.retryKey)
        }
    }
}
