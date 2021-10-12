//
//  ContentView.swift
//  Project8_Moonshot
//
//  Created by Tyler Edwards on 10/12/21.
//

import SwiftUI

struct ContentView: View {

    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    
    @State private var secondaryDisplay = SecondaryDisplay.date
    
    var body: some View {
        NavigationView {
            List(Self.missions) { mission in
                NavigationLink(destination: MissionView(mission: mission)) {
                    MissionBadgeView(mission: mission, secondaryDisplay: secondaryDisplay)
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems( trailing: displayToggleBarButton())
        }
    }
    
    func displayToggleBarButton() -> some View {
        switch(secondaryDisplay) {
        case .crew:
            return Button("Show Date") {
                secondaryDisplay = .date
            }
            
        case .date:
            return Button("Show Crew") {
                secondaryDisplay = .crew
            }
        }
    }

}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
