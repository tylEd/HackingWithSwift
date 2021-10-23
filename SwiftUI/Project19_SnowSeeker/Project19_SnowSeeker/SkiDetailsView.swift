//
//  SkiDetailsView.swift
//  Project19_SnowSeeker
//
//  Created by Tyler Edwards on 10/23/21.
//

import SwiftUI


struct SkiDetailsView: View {
    let resort: Resort
    
    var body: some View {
        Group {
            Text("Elevation: \(resort.elevation)m").layoutPriority(1)
            Spacer().frame(height: 0)
            Text("Snow: \(resort.snowDepth)cm").layoutPriority(1)
        }
    }
}


struct SkiDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        SkiDetailsView(resort: Resort.example)
    }
}
