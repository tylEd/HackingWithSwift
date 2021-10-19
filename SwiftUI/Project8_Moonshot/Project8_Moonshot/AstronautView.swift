//
//  AstronautView.swift
//  Project8_Moonshot
//
//  Created by Tyler Edwards on 10/12/21.
//

import SwiftUI

struct AstronautView: View {
    
    let astronaut: Astronaut
    let missions: [Mission]
    
    init(astronaut: Astronaut) {
        self.astronaut = astronaut
        
        self.missions = ContentView.missions
            .filter({ mission in
                mission.crew.contains(where: { $0.name == astronaut.id })
            })
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    Image(astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                        .accessibility(hidden: true)
                    
                    Text(astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    ForEach(missions) { mission in
                        MissionBadgeView(mission: mission).padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}
