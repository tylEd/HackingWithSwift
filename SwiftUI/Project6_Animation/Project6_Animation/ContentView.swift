//
//  ContentView.swift
//  Project6_Animation
//
//  Created by Tyler Edwards on 10/10/21.
//

import SwiftUI


struct ImplicitAnimations: View {
    @State private var animAmount = CGFloat(1)
    var body: some View {
        Button("Tap Me") {
            //self.animAmount += 1
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .overlay(
            Circle().stroke(Color.red)
                .scaleEffect(animAmount)
                .opacity(Double(2 - animAmount))
                .animation(
                    Animation.easeInOut(duration: 1)
                        .repeatForever(autoreverses: false)
                )
        )
        .onAppear {
            self.animAmount = 2
        }
    }
}


struct AnimatingBindings: View {
    @State private var animAmount = CGFloat(1)
    
    var body: some View {
        print(animAmount)
        
        return VStack {
            Stepper("Scale amount", value: $animAmount.animation(
                Animation.easeInOut(duration: 1)
                    .repeatCount(3, autoreverses: true)
            ), in: 1...10)
            
            Spacer()
            
            Button("Tap Me") {
                self.animAmount += 1
            }
            .padding(40)
            .background(Color.red)
            .foregroundColor(.white)
            .clipShape(Circle())
            .scaleEffect(animAmount)
        }
    }
}


struct ExplicitAnimations: View {
    @State private var animAmount = 0.0
    
    var body: some View {
        Button("Tap Me") {
            withAnimation(.interpolatingSpring(stiffness: 5, damping: 1)) {
                self.animAmount += 360
            }
        }
        .padding(50)
        .background(Color.red)
        .foregroundColor(.white)
        .clipShape(Circle())
        .rotation3DEffect(.degrees(animAmount), axis: (x: 0, y: 1, z: 0))
    }
}


struct AnimationStack: View {
    @State private var enabled = false
    
    var body: some View {
        Button("Tap Me") {
            self.enabled.toggle()
        }
        .frame(width: 200, height: 200)
        .background(enabled ? Color.blue : Color.red)
        //NOTE: Only changes that appear before the animation modifier get animated
        .animation(nil)//.default)
        //      Allows having different animations for each property.
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: enabled ? 60 : 0))
        .animation(.interpolatingSpring(stiffness: 10, damping: 1))
        
    }
}


struct AnimtingGestures1: View {
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.yellow, .red]), startPoint: .topLeading, endPoint: .bottomTrailing)
            .frame(width: 300, height: 200)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .offset(dragAmount)
            .gesture(
                DragGesture()
                    .onChanged { self.dragAmount = $0.translation }
                    .onEnded { _ in
                        withAnimation(.spring()) {
                            self.dragAmount = .zero
                        }
                    }
            )
    }
}


struct AnimtingGestures2: View {
    let letters = Array("Hello SwiftUI")
    @State private var enabled = false
    @State private var dragAmount = CGSize.zero
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< letters.count) { num in
                Text(String(self.letters[num]))
                    .padding(5)
                    .font(.title)
                    .background(self.enabled ? Color.blue : Color.red)
                    .offset(self.dragAmount)
                    .animation(.default.delay(Double(num) / 20))
                
            }
        }
        .gesture(
            DragGesture()
                .onChanged { self.dragAmount = $0.translation }
                .onEnded { _ in
                    self.dragAmount = .zero
                    self.enabled.toggle()
                }
        )
    }
}


struct Transitions: View {
    @State private var isShowingRed = false
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    .transition(.asymmetric(insertion: .scale, removal: .opacity))
            }
        }
    }
}


//MARK: Custom Transitions


struct CornerRotateModifier: ViewModifier {
    let amount: Double
    let anchor: UnitPoint
    
    func body(content: Content) -> some View {
        content.rotationEffect(.degrees(amount), anchor: anchor)
            .clipped()
    }
}


extension AnyTransition {
    static var pivot: AnyTransition {
        .modifier(active: CornerRotateModifier(amount: -90, anchor: .topLeading),
                  identity: CornerRotateModifier(amount: 0, anchor: .topLeading))
    }
}


struct CustomTransitions: View {
    @State private var isShowingRed = false
    var body: some View {
        VStack {
            Button("Tap Me") {
                withAnimation {
                    isShowingRed.toggle()
                }
            }
            
            if isShowingRed {
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 200, height: 200)
                    .transition(.pivot)
            }
        }
    }
}


//MARK: Overview


struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ImplicitAnimations(), label: { Text("Implicit Animations") })
                NavigationLink(destination: AnimatingBindings(), label: { Text("Animating Bindings") })
                NavigationLink(destination: ExplicitAnimations(), label: { Text("Explicit Animations") })
                NavigationLink(destination: AnimationStack(), label: { Text("Animation Stack") })
                NavigationLink(destination: AnimtingGestures1(), label: { Text("Animating Gestures") })
                NavigationLink(destination: AnimtingGestures2(), label: { Text("Animating Gestures 2") })
                NavigationLink(destination: Transitions(), label: { Text("Transitions") })
                NavigationLink(destination: CustomTransitions(), label: { Text("Custom Transitions") })
            }
            .navigationBarTitle("Animation")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

