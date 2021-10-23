//
//  ContentView.swift
//  Project5_WordScramble
//
//  Created by Tyler Edwards on 10/9/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    
    @State private var errorTitle = ""
    @State private var errorMsg = ""
    @State private var showingError = false
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .padding()
                
                GeometryReader { listGeo in
                    List(usedWords, id: \.self) { word in
                        GeometryReader { rowGeo in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                    .foregroundColor(Color(red: 1.0 - rowLocation(listGeo, rowGeo), green: 0.3, blue: 1.0))
                                Text(word)
                            }
                            .offset(x: rowOffset(listGeo, rowGeo))
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text("\(word), \(word.count) letters"))
                        }
                    }
                }
                
                Text("Score: \(clacScore())")
            }
            .navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .navigationBarItems(leading: Button("New Game", action: startGame))
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle),
                      message: Text(errorMsg),
                      dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func rowOffset(_ listGeo: GeometryProxy, _ rowGeo: GeometryProxy) -> CGFloat {
        let loc = rowLocation(listGeo, rowGeo)
        
        if loc > 0.8 {
            let fraction = loc - 0.8
            return CGFloat(fraction * 200)
        }
        
        return 0
    }
    
    func rowLocation(_ listGeo: GeometryProxy, _ rowGeo: GeometryProxy) -> Double {
        let top = listGeo.frame(in: .global).minY
        let location = (rowGeo.frame(in: .global).midY - top) / listGeo.size.height
        return Double(location)
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard answer.count > 0 else {
            return
        }
        
        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", msg: "Be more original")
            return
        }
        
        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", msg: "You can't just make them up you know!")
            return
        }
        
        guard isReal(word: answer) else {
            wordError(title: "Word not real", msg: "That isn't a real word.")
            return
        }
        
        guard answer.count > 2 else {
            wordError(title: "Word too short", msg: "Words must be 3 letters or longer.")
            return
        }
        
        guard answer != rootWord else {
            wordError(title: "That's just the root word.", msg: "You'll have to be more creative than that.")
            return
        }
        
        usedWords.insert(answer, at: 0)
        newWord = ""
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
                usedWords = []
                newWord = ""
                return
            }
        }
        
        fatalError("Could not load \"start.txt\" from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        !usedWords.contains(word)
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord.lowercased()
        
        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, msg: String) {
        errorTitle = title
        errorMsg = msg
        showingError = true
    }
    
    func clacScore() -> Int { usedWords.map({ $0.count }).reduce(0, +) }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
