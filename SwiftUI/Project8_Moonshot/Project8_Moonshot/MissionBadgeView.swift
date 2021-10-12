//
//  MissionBadgeView.swift
//  Project8_Moonshot
//
//  Created by Tyler Edwards on 10/12/21.
//

import SwiftUI

enum SecondaryDisplay: Int {
    case crew, date
}

struct MissionBadgeView: View {
    
    var mission: Mission
    var secondaryDisplay = SecondaryDisplay.crew
    
    var body: some View {
        HStack {
            Image(mission.image)
                .resizable()
                .frame(width: 44, height: 44)
            
            VStack(alignment: .leading) {
                Text(mission.displayName)
                    .font(.headline)
                
                switch(secondaryDisplay) {
                case .crew:
                    Text(mission.crewNames)
                        .foregroundColor(.secondary)
                case .date:
                    Text(mission.formattedLaunchDate)
                        .foregroundColor(.secondary)
                }
            }
            
            Spacer()
        }
    }
    
}

struct MissionBadgeView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")

    static var previews: some View {
        MissionBadgeView(mission: missions[0])
    }
}
