//
//  ContentView.swift
//  Project2_GuessTheFlag
//
//  Created by Tyler Edwards on 10/6/21.
//

import SwiftUI

struct ContentView: View {
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner",
    ]
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var score = 0
    
    // Animation
    @State private var correctFlagRotationAmount = 0.0
    @State private var otherFlagsOpacity = 1.0
    @State private var wrongRotation = 0.0
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                VStack {
                    Text("Tap the flag of")
                        .foregroundColor(.white)
                    Text(countries[correctAnswer])
                        .foregroundColor(.white)
                        .font(.largeTitle)
                        .fontWeight(.black)
                }
                
                ForEach(0 ..< 3) { number in
                    Button(action: {
                        flagTapped(number)
                    }) {
                        if number == correctAnswer {
                            FlagImage(self.countries[number])
                                .rotation3DEffect(.degrees(correctFlagRotationAmount), axis: (x: 0, y: 1, z: 0))
                                .accessibility(label: Text(labels[countries[number], default: "Unknown flag"]))
                        } else {
                            FlagImage(self.countries[number])
                                .opacity(otherFlagsOpacity)
                                .rotation3DEffect(.degrees(wrongRotation), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
                                .accessibility(label: Text(labels[countries[number], default: "Unknown flag"]))
                        }
                    }
                }
                
                Text("Score: \(score)")
                    .foregroundColor(.white)
                
                Spacer()
            }
        }
        .alert(isPresented: $showingScore) {
            Alert(title: Text(scoreTitle),
                  message: Text("Your score is \(score)"),
                  dismissButton: .default(Text("Continue")){
                    self.askQuestion()
                  })
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct!"
            score += 1
            
            withAnimation {
                correctFlagRotationAmount += 360
                otherFlagsOpacity = 0.25
            }
        } else {
            scoreTitle = "Wrong! That's the flage of \(countries[number])"
            score -= 1
            
            withAnimation(.easeIn) {
                wrongRotation = 90
            }
        }
        
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        // Reset Animations
        correctFlagRotationAmount = 0
        otherFlagsOpacity = 1
        wrongRotation = 0
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
