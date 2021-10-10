//
//  ContentView.swift
//  Project2_GuessTheFlag
//
//  Created by Tyler Edwards on 10/6/21.
//

import SwiftUI

struct ContentView: View {
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
                        } else {
                            FlagImage(self.countries[number])
                                .opacity(otherFlagsOpacity)
                                .rotation3DEffect(.degrees(wrongRotation), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
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
