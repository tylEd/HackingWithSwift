//
//  ContentView.swift
//  Project15_Accessibility
//
//  Created by Tyler Edwards on 10/19/21.
//

import SwiftUI


struct LabelsAndTraits_ContentView: View {
    let pictures = [
        "ales-krivec-15949",
        "galina-n-189483",
        "kevin-horstmann-141705",
        "nicolas-tissot-335096",
    ]
    
    let labels = [
        "Tulips",
        "Frozen tree buds",
        "Sunflowers",
        "Fireworks",
    ]
    
    @State private var selectedPic = Int.random(in: 0...3)
    
    var body: some View {
        Image(pictures[selectedPic])
            .resizable()
            .scaledToFit()
            .accessibility(label: Text(labels[selectedPic]))
            .accessibilityAddTraits(.isButton)
            .accessibilityRemoveTraits(.isImage)
            .onTapGesture {
                self.selectedPic = Int.random(in: 0...3)
            }
    }
}


struct HidingAndGrouping_ContentView: View {
    var body: some View {
        VStack {
            Image(decorative: "ales-krivec-15949")
                .resizable()
                .scaledToFit()
                .accessibility(hidden: true)
            
            VStack {
                Text("Your score is")
                Text("1000")
                    .font(.title)
            }
            .accessibilityElement(children: .ignore)
            .accessibility(label: Text("Your score is 1000"))
            
        }
    }
}


struct /*Value_*/ContentView: View {
    @State private var estimate = 25.0
    @State private var rating = 3
    
    var body: some View {
        VStack {
            Slider(value: $estimate, in: 0...50)
                .padding()
                .accessibility(value: Text("\(Int(estimate))"))
            
            Stepper("Rate our service: \(rating)/5", value: $rating, in: 1...5)
                .accessibility(value: Text("\(rating) out of 5"))
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
