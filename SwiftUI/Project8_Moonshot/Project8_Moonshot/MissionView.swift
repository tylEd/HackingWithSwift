//
//  MissionView.swift
//  Project8_Moonshot
//
//  Created by Tyler Edwards on 10/12/21.
//

import SwiftUI


struct MissionView: View {
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    let mission: Mission
    let astronauts: [CrewMember]
    
    init(mission: Mission) {
        self.mission = mission
        
        var matches = [CrewMember]()
        
        for member in mission.crew {
            if let match = ContentView.astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        
        self.astronauts = matches
    }
    
    var body: some View {
        GeometryReader { geo in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { localGeo in
                        let frame = localGeo.frame(in: .named("Scroll"))
                        let visibleScale: CGFloat = frame.minY < 0 ? (frame.height + frame.minY) / frame.height : 1.0
                        let scale = max(visibleScale, 0.5)
                        Image(mission.image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: localGeo.size.width, height: localGeo.size.height)
                            .scaleEffect(scale)
                            .offset(y: (1-scale) / 2 * localGeo.size.height)
                            .accessibility(hidden: true)
                    }
                    .frame(height: geo.size.width * 0.7)
                    .padding(.top)

                    Text(mission.formattedLaunchDate)
                        .foregroundColor(.secondary)
                    
                    Text(mission.description)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding()

                    ForEach(astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))
                                
                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }
                                
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
            .coordinateSpace(name: "Scroll")
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    
    static var previews: some View {
        MissionView(mission: missions[0])
    }
}
