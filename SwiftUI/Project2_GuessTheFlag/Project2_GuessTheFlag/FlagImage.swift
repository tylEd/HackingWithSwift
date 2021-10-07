//
//  FlagImage.swift
//  Project2_GuessTheFlag
//
//  Created by Tyler Edwards on 10/7/21.
//

import SwiftUI

struct FlagImage: View {
    var imageName: String
    
    init(_ imageName: String) {
        self.imageName = imageName
    }
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.black, lineWidth: 1))
            .shadow(color: .black, radius: 2)
    }
}

struct FlagImage_Previews: PreviewProvider {
    static var previews: some View {
        FlagImage("US")
    }
}
