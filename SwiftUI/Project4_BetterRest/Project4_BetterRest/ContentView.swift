//
//  ContentView.swift
//  Project4_BetterRest
//
//  Created by Tyler Edwards on 10/8/21.
//

import SwiftUI
import CoreML

struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMsg = ""
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("When do you want to wake up?")) {
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                        .datePickerStyle(WheelDatePickerStyle())
                }
                
                //VStack(alignment: .leading, spacing: 0) {
                Section(header: Text("Desired amount of sleep")) {
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") hours")
                    }
                }
                
                Section {
                    Picker("Daily coffee intake", selection: $coffeeAmount) {
                        ForEach(0..<21) { cupCount in
                            Text("\(cupCount)")
                        }
                    }
                }
                
                Section(header: Text("Ideal bedtime")) {
                    let bedtime = calculateBedtime()
                    Text(bedtime ?? "Error")
                        .font(.headline)
                        .foregroundColor(bedtime == nil ? .red : .primary)
                }
            }
            .navigationBarTitle("BetterRest")
            //.navigationBarItems(trailing: Button("Calculate", action: calculateBedtime))
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMsg), dismissButton: .default(Text("OK")))
            }
            
        }
    }
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }
    
    func calculateBedtime() -> String? {
        do {
            let model = try SleepCalculator(configuration: MLModelConfiguration())
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0) * 60 * 60
            let minute = (components.minute ?? 0) * 60
            
            let prediction = try model.prediction(wake: Double(hour + minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            return formatter.string(from: sleepTime)
        } catch {
            alertTitle = "Error"
            alertMsg = "Sorry, there was a problem calculating your bedtime."
            showingAlert = true
        }
        
        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
