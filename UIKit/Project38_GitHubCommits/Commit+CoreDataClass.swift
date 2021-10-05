//
//  Commit+CoreDataClass.swift
//  Project38_GitHubCommits
//
//  Created by Tyler Edwards on 10/1/21.
//
//

import Foundation
import CoreData

@objc(Commit)
public class Commit: NSManagedObject {
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
        print("Init called!")
    }
    
}
