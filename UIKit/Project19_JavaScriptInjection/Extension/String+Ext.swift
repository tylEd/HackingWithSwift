//
//  String+Ext.swift
//  Extension
//
//  Created by Tyler Edwards on 10/4/21.
//

import Foundation


extension String {
    
    func withSuffix(_ suffix: String) -> String {
        if self.hasSuffix(suffix) {
            return self
        } else {
            return self + suffix
        }
    }
    
    func removingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
    
}
