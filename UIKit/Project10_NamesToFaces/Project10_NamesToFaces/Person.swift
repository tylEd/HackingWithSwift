//
//  Person.swift
//  Project10_NamesToFaces
//
//  Created by Tyler Edwards on 9/4/21.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
