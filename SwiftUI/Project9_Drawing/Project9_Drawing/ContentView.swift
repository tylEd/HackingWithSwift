//
//  ContentView.swift
//  Project9_Drawing
//
//  Created by Tyler Edwards on 10/13/21.
//

import SwiftUI


//MARK: Path Drawing


struct Ex1_PathDrawing: View {
    var body: some View {
        Path { path in
            path.move(to: CGPoint(x: 200, y: 100))
            path.addLine(to: CGPoint(x: 100, y: 300))
            path.addLine(to: CGPoint(x: 300, y: 300))
            path.addLine(to: CGPoint(x: 200, y: 100))
            
            path.addLine(to: CGPoint(x: 100, y: 300))
        }
        .stroke(Color.blue.opacity(0.25), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
    }
}


//MARK: Shape Drawing


struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}


struct Arc: InsettableShape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise: Bool
    var insetAmount: CGFloat = 0
    
    func path(in rect: CGRect) -> Path {
        let rotationAdjustment = Angle.degrees(90)
        let modifiedStart = startAngle - rotationAdjustment
        let modifiedEnd = endAngle - rotationAdjustment
        
        var path = Path()
        
        path.addArc(center: CGPoint(x: rect.midX, y: rect.midY), radius: rect.width / 2 - insetAmount, startAngle: modifiedStart, endAngle: modifiedEnd, clockwise: !clockwise)
        
        return path
    }
    
    func inset(by amount: CGFloat) -> some InsettableShape {
        var arc = self
        arc.insetAmount += amount
        return arc
    }
}


struct Ex2_ShapeDrawing: View {
    var body: some View {
        VStack {
            Triangle()
                .stroke(Color.red.opacity(0.35), style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .frame(width: 300, height: 300)
            
            Spacer()
            
            Arc(startAngle: .degrees(0), endAngle: .degrees(110), clockwise: true)
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                .frame(width: 300, height: 300)
        }
        .padding()
    }
}


//MARK: strokeBorder() and InsettableShape


struct Ex3_InsettableShapes: View {
    var body: some View {
        Arc(startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
            .strokeBorder(Color.blue, lineWidth: 40)
    }
}


//MARK: CGAffineTransform and even-odd fills


struct Flower: Shape {
    var petalOffset: Double = -20
    var petalWidth: Double = 100
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        for number in stride(from: 0, to: CGFloat.pi * 2, by: CGFloat.pi / 8) {
            let rotation = CGAffineTransform(rotationAngle: number)
            let position = rotation.concatenating(CGAffineTransform(translationX: rect.width / 2, y: rect.height / 2))
            
            let originalPetal = Path(ellipseIn: CGRect(x: CGFloat(petalOffset),
                                                       y: 0,
                                                       width: CGFloat(petalWidth),
                                                       height: rect.width / 2))
            let rotatedPetal = originalPetal.applying(position)
            
            path.addPath(rotatedPetal)
        }
        
        return path
    }
}


struct Ex4_TransformsAndEOFill: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    
    var body: some View {
        VStack {
            Flower(petalOffset: petalOffset, petalWidth: petalWidth)
                //.stroke(Color.red, lineWidth: 1)
                .fill(Color.red, style: FillStyle(eoFill: true))
            
            Text("Offset")
            Slider(value: $petalOffset, in: -40...40)
                .padding([.horizontal, .bottom])
            
            Text("Width")
            Slider(value: $petalWidth, in: 0...100)
                .padding(.horizontal)
        }
    }
}


//MARK: ImagePaint


struct Ex5_ImagePaint: View {
    @State private var petalOffset = -20.0
    @State private var petalWidth = 100.0
    
    var body: some View {
        VStack {
            Spacer()
            
            Text("Hello World")
                .frame(width: 300, height: 300)
                .border(ImagePaint(image: Image("Example"),
                                   sourceRect: CGRect(x: 0, y: 0.25, width: 1, height: 0.5),
                                   scale: 0.1),
                        width: 30)
            
            Spacer()
            
            Capsule()
                .strokeBorder(ImagePaint(image: Image("Example"), scale: 0.1), lineWidth: 20)
                .frame(width: 300, height: 200)
            
            Spacer()
        }
    }
}


//MARK: drawingGroup() and Metal


struct ColorCyclingCircle: View {
    var amount = 0.0
    var steps = 100
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Circle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [self.color(for: value, brightness: 1), self.color(for: value, brightness: 0.5)]),
                                                 startPoint: .top,
                                                 endPoint: .bottom),
                                  lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}


struct Ex6_DrawingGroup: View {
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            ColorCyclingCircle(amount: self.colorCycle)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCycle)
        }
    }
}


//MARK: Effects (Blur, Blending, etc)


struct Ex7_Effects: View {
    @State private var amount: CGFloat = 0.0
    
    var body: some View {
        VStack {
            GeometryReader { geo in
                ScrollView(.vertical) {
                    // Blend Modes
                    Image("Example")
                        .resizable()
                        .colorMultiply(.red)
                        .frame(width: 100, height: 100)
                        .padding()
                    
                    // Screen Blend Mode
                    VStack(spacing: 20) {
                        ZStack {
                            Circle()
                                .fill(Color(red: 1, green: 0, blue: 0))
                                .frame(width: 200 * amount)
                                .offset(x: -50, y: -80)
                                .blendMode(.screen)
                            
                            Circle()
                                .fill(Color(red: 0, green: 1, blue: 0))
                                .frame(width: 200 * amount)
                                .offset(x: 50, y: -80)
                                .blendMode(.screen)
                            
                            Circle()
                                .fill(Color(red: 0, green: 0, blue: 1))
                                .frame(width: 200 * amount)
                                .blendMode(.screen)
                        }
                        .frame(width: 300, height: 300)
                    }
                    .frame(width: geo.size.width, height: geo.size.height)
                    .background(Color.black)
                    
                    // Saturation and Blur
                    VStack {
                        Image("Example")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                            .saturation(Double(amount))
                            .blur(radius: (1 - amount) * 20)
                    }
                    .frame(width: geo.size.width, height: geo.size.height / 2)
                    .background(Color.black)
                }
            }
            
            Slider(value: $amount)
                .padding()
        }
    }
}


//MARK: Animating shapes (animatableData)


struct Trapezoid: Shape {
    var insetAmount: CGFloat
    
    var animatableData: CGFloat {
        get { insetAmount }
        set { self.insetAmount = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: 0, y: rect.maxY))
        path.addLine(to: CGPoint(x: insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - insetAmount, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: 0, y: rect.maxY))
        
        return path
    }
}


struct Ex8_Animating: View {
    @State private var insetAmount: CGFloat = 50
    
    var body: some View {
        Trapezoid(insetAmount: insetAmount)
            .frame(width: 200, height: 100)
            .onTapGesture {
                withAnimation {
                    self.insetAmount = CGFloat.random(in: 10...90)
                }
            }
    }
}


//MARK: Animating Complex Shapes (AnimatablePar)


struct CheckerBoard: Shape {
    var rows: Int
    var columns: Int
    
    public var animatableData: AnimatablePair<Double, Double> {
        get {
            AnimatablePair(Double(rows), Double(columns))
        }
        
        set {
            self.rows = Int(newValue.first)
            self.columns = Int(newValue.second)
        }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let rowSize = rect.height / CGFloat(rows)
        let columnSize = rect.width / CGFloat(columns)
        
        for row in 0..<rows {
            for column in 0..<columns {
                if (row + column).isMultiple(of: 2) {
                    let startX = columnSize * CGFloat(column)
                    let startY = rowSize * CGFloat(row)
                    
                    let rect = CGRect(x: startX, y: startY, width: columnSize, height: rowSize)
                    
                    path.addRect(rect)
                }
            }
        }
        
        return path
    }
}


struct Ex9_ComplexAnimations: View {
    @State private var rows = 4
    @State private var columns = 4
    
    var body: some View {
        CheckerBoard(rows: rows, columns: columns)
            .onTapGesture {
                withAnimation(.linear(duration: 3)) {
                    self.rows = 8
                    self.columns = 16
                }
            }
    }
}


//MARK: Spirograph


struct Spirograph: Shape {
    let innerRadius: Int
    let outerRadius: Int
    let distance: Int
    let amount: CGFloat
    
    func gcd(_ a: Int, _ b: Int) -> Int {
        var a = a
        var b = b
        
        while b != 0 {
            let temp = b
            b = a % b
            a = temp
        }
        
        return a
    }
    
    func path(in rect: CGRect) -> Path {
        let divisor = gcd(innerRadius, outerRadius)
        let outerRadius = CGFloat(self.outerRadius)
        let innerRadius = CGFloat(self.innerRadius)
        let distance = CGFloat(self.distance)
        let difference = innerRadius - outerRadius
        let endPoint = ceil(2 * CGFloat.pi * outerRadius / CGFloat(divisor)) * amount
        
        var path = Path()
        
        for theta in stride(from: 0, through: endPoint, by: 0.01) {
            var x = difference * cos(theta) + distance * cos(difference / outerRadius * theta)
            var y = difference * sin(theta) - distance * sin(difference / outerRadius * theta)
            
            x += rect.width / 2
            y += rect.height / 2
            
            if theta == 0 {
                path.move(to: CGPoint(x: x, y: y))
            } else {
                path.addLine(to: CGPoint(x: x, y: y))
            }
        }
        
        return path
    }
}


struct Ex10_Spirograph: View {
    @State private var innerRadius = 125.0
    @State private var outerRadius = 75.0
    @State private var distance = 25.0
    @State private var amount: CGFloat = 1.0
    @State private var hue = 0.6
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            Spirograph(innerRadius: Int(innerRadius), outerRadius: Int(outerRadius), distance: Int(distance), amount: amount)
                .stroke(Color(hue: hue, saturation: 1, brightness: 1))
                .frame(width: 300, height: 300)
            
            Spacer()
            
            Group {
                Text("Inner radius: \(Int(innerRadius))")
                Slider(value: $innerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Outer radius: \(Int(outerRadius))")
                Slider(value: $outerRadius, in: 10...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Distance: \(Int(distance))")
                Slider(value: $distance, in: 1...150, step: 1)
                    .padding([.horizontal, .bottom])
                
                Text("Amount: \(amount, specifier: "%.2f")")
                Slider(value: $amount)
                    .padding([.horizontal, .bottom])
                
                Text("Color")
                Slider(value: $hue)
                    .padding(.horizontal)
            }
        }
    }
}


//MARK: Challenge 1


struct Arrow: Shape {
    var width: CGFloat = 4
    
    var animatableData: CGFloat {
        get { width }
        set { self.width = newValue }
    }

    func path(in rect: CGRect) -> Path {
        let halfWidth = width / 2
        
        var path = Path()
        
        path.addRect(CGRect(x: rect.midX - halfWidth, y: rect.midY - (rect.height / 4), width: width, height: rect.height / 2))
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX - (width * 2), y: rect.midY - (rect.height / 4)))
        path.addLine(to: CGPoint(x: rect.midX + (width * 2), y: rect.midY - (rect.height / 4)))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}


struct Ch1_Arrow: View {
    var body: some View {
        Arrow(width: 15)
            .frame(width: 300, height: 300)
    }
}


//MARK: Challenge 2


struct Ch2_ArrowAnimated: View {
    @State private var width: CGFloat = 2
    
    var body: some View {
        Arrow(width: width)
            .frame(width: 300, height: 300)
            .onAppear {
                withAnimation(.easeInOut(duration: 1).repeatForever(autoreverses: true)) {
                    width = 20
                }
            }
    }
}


//MARK: Challenge 3


struct ColorCyclingRectangle: View {
    var amount = 0.0
    var steps = 100
    
    var gradientStart = UnitPoint.top
    var gradientEnd = UnitPoint.bottom
    
    var body: some View {
        ZStack {
            ForEach(0..<steps) { value in
                Rectangle()
                    .inset(by: CGFloat(value))
                    .strokeBorder(LinearGradient(gradient: Gradient(colors: [self.color(for: value, brightness: 1), self.color(for: value, brightness: 0.5)]),
                                                 startPoint: gradientStart,
                                                 endPoint: gradientEnd),
                                  lineWidth: 2)
            }
        }
        .drawingGroup()
    }
    
    func color(for value: Int, brightness: Double) -> Color {
        var targetHue = Double(value) / Double(self.steps) + self.amount
        
        if targetHue > 1 {
            targetHue -= 1
        }
        
        return Color(hue: targetHue, saturation: 1, brightness: brightness)
    }
}


struct Ch3_ColorCyclingRect: View {
    @State private var colorCycle = 0.0
    
    var body: some View {
        VStack {
            ColorCyclingRectangle(amount: self.colorCycle, gradientStart: .leading, gradientEnd: .trailing)
                .frame(width: 300, height: 300)
            
            Slider(value: $colorCycle)
        }
    }
}


//MARK: ContentView


struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Examples")) {
                    NavigationLink(destination: Ex1_PathDrawing()) {
                        Text("Path Drawing")
                    }
                    
                    NavigationLink(destination: Ex2_ShapeDrawing()) {
                        Text("Shape Drawing")
                    }
                    
                    NavigationLink(destination: Ex4_TransformsAndEOFill()) {
                        Text("CGAffineTransform and even-odd fills")
                    }
                    
                    NavigationLink(destination: Ex5_ImagePaint()) {
                        Text("ImagePaint")
                    }
                    
                    NavigationLink(destination: Ex6_DrawingGroup()) {
                        Text("drawingGroup() and Metal")
                    }
                    
                    NavigationLink(destination: Ex7_Effects()) {
                        Text("Effects (Blur, Blending, etc)")
                    }
                    
                    NavigationLink(destination: Ex8_Animating()) {
                        Text("Animating shapes (animatableData)")
                    }
                    
                    NavigationLink(destination: Ex9_ComplexAnimations()) {
                        Text("Animating Complex Shapes (AnimatablePar)")
                    }
                    
                    NavigationLink(destination: Ex10_Spirograph()) {
                        Text("Spirograph")
                    }
                }
                
                Section(header: Text("Challenges")) {
                    NavigationLink(destination: Ch1_Arrow()) {
                        Text("Arrow")
                    }
                    
                    NavigationLink(destination: Ch2_ArrowAnimated()) {
                        Text("Arrow Animated")
                    }
                    
                    NavigationLink(destination: Ch3_ColorCyclingRect()) {
                        Text("Color Cycling Rectangle")
                    }
                }
            }
            .navigationBarTitle("Drawing")
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

