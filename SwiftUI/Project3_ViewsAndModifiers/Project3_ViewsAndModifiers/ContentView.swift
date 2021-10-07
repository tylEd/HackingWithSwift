//
//  ContentView.swift
//  Project3_ViewsAndModifiers
//
//  Created by Tyler Edwards on 10/7/21.
//

import SwiftUI


struct Example_1: View {
    var body: some View {
        Text("Hello, world!")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.red)
            .edgesIgnoringSafeArea(.all)
    }
}


// MARK: Modifier order matters


struct Example_2: View {
    var body: some View {
        //NOTE: Order matters
        VStack {
            Button("Hello, world!") {
                print(type(of: self.body))
            } // Frame applied before setting the background here.
            .frame(width: 200, height: 200)
            .background(Color.red)
            
            Text("Hello World")
                .padding()
                .background(Color.red)
                .padding()
                .background(Color.blue)
                .padding()
                .background(Color.green)
                .padding()
                .background(Color.yellow)
        }
    }
}


// MARK: Conditional Modifiers


struct Example_3: View {
    @State private var useRedText = false
    
    var body: some View {
        Button("Hello, world!") {
            self.useRedText.toggle()
        }
        .foregroundColor(useRedText ? .red : .blue)
    }
    
    /* NOTE: Doesn't compile. Text and Background are different View types.
    var badBody: some View {
        if self.useRedText {
            return Text("Hello World")
        } else {
            return Text("Hello World")
                .background(Color.red)
        }
    }*/
}


// MARK: Environment Modifiers


struct Example_4: View {
    var body: some View {
        VStack(spacing: 40) {
            envMods
            nonEnvMods
        }
    }
    
    var envMods: some View {
        VStack {
            Text("Gryffindor")
                .font(.largeTitle) //NOTE: Environment modifiers can be overridden
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .font(.caption) //NOTE: Environment modifiers affect everything in the container
    }
    
    var nonEnvMods: some View {
        VStack {
            Text("Gryffindor")
                .blur(radius: 0) //NOTE: Non-environment mods can't be overridden
            Text("Hufflepuff")
            Text("Ravenclaw")
            Text("Slytherin")
        }
        .blur(radius: 5)
    }
}


// MARK: Views as Properties


struct Example_5: View {
    var motto1: some View { Text("Draco dormiens") }
    let motto2 = Text("nunquam titillandus")
    
    var body: some View {
        VStack {
            motto1.foregroundColor(.red)
            motto2.foregroundColor(.blue)
        }
    }
}


// MARK: View Composition


struct CapsuleText: View {
    var text: String
    
    var body: some View {
        Text(text)
            .font(.largeTitle)
            .padding()
            //.foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}


struct Example_6: View {
    var body: some View {
        VStack {
            CapsuleText(text: "First")
                .foregroundColor(.white)
            CapsuleText(text: "Second")
                .foregroundColor(.yellow)
        }
    }
}


//MARK: Custom Modifiers


struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.white)
            .padding()
            .background(Color.blue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}


struct Watermark: ViewModifier {
    var text: String
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottomTrailing) {
            content
            
            Text(text)
                .font(.caption)
                .foregroundColor(.white)
                .padding(5)
                .background(Color.black)
        }
    }
}


extension View {
    func titleStyle() -> some View {
        self.modifier(Title())
    }
    
    func watermarked(with text: String) -> some View {
        self.modifier(Watermark(text: text))
    }
}


struct Example_7: View {
    var body: some View {
        VStack {
            title
            watermark
        }
    }
    
    var title: some View {
        Text("Hello, world!")
            .titleStyle()
    }
    
    var watermark: some View {
        Color.blue
            .frame(width: 300, height: 300)
            .watermarked(with: "HWS")
    }
}


//MARK: Custom Containers


struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content
    
    init(rows: Int, columns: Int, @ViewBuilder content: @escaping (Int, Int) -> Content) {
        self.rows = rows
        self.columns = columns
        self.content = content
    }
    
    var body: some View {
        VStack {
            ForEach(0 ..< rows) { row in
                HStack {
                    ForEach(0 ..< columns) { column in
                        content(row, column)
                    }
                }
            }
        }
    }
}


struct Example_8: View {
    var body: some View {
        GridStack(rows: 4, columns: 4) { row, col in
            //HStack { NOTE: ViewBuilder gives an implicit HStack
            Image(systemName: "\(row * 4 + col).circle")
            Text("R\(row) C\(col)")
        }
    }
}


//MARK: Challenges


struct BigBlueFont: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.largeTitle)
            .foregroundColor(.blue)
    }
}


extension View {
    func bigBlueFont() -> some View {
        self.modifier(BigBlueFont())
    }
}


struct Challenge_1: View {
    var body: some View {
        Text("Big Blue Title")
            .bigBlueFont()
    }
}


//MARK: Demo


struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: Example_1().navigationBarTitle("Example_1"),
                               label: { Text("Example 1") })
                
                NavigationLink(destination: Example_2().navigationBarTitle("Example_2"),
                               label: { Text("Modifier order matters") })
                
                NavigationLink(destination: Example_3().navigationBarTitle("Example_3"),
                               label: { Text("Conditional Modifiers") })
                
                NavigationLink(destination: Example_4().navigationBarTitle("Example_4"),
                               label: { Text("Environment Modifiers") })
                
                NavigationLink(destination: Example_5().navigationBarTitle("Example_5"),
                               label: { Text("Views as Properties") })
                
                NavigationLink(destination: Example_6().navigationBarTitle("Example_6"),
                               label: { Text("View Composition") })
                
                NavigationLink(destination: Example_7().navigationBarTitle("Example_7"),
                               label: { Text("Custom Modifiers") })
                
                NavigationLink(destination: Example_8().navigationBarTitle("Example_8"),
                               label: { Text("Custom Containers") })
                
                NavigationLink(destination: Challenge_1().navigationBarTitle("Challenge_1"),
                               label: { Text("Challenge") })
            }
            .navigationBarTitle("Views and Modifiers")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

