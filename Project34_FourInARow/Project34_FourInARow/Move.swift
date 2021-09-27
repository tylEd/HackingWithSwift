//
//  Move.swift
//  Project34_FourInARow
//
//  Created by Tyler Edwards on 9/27/21.
//

import UIKit
import GameplayKit

class Move: NSObject, GKGameModelUpdate {
    var value: Int = 0
    var column: Int
    
    init(column: Int) {
        self.column = column
    }
    
}
