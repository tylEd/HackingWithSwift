//
//  ContentView.swift
//  Project1_WeSplit
//
//  Created by Tyler Edwards on 10/5/21.
//

import SwiftUI

struct ContentView: View {
    @State private var checkAmount = ""
    //@State private var numberOfPeople = 2
    @State private var numberOfPeople = ""
    @State private var tipPercentage = 2
    
    let tipPercentages = [10, 15, 20, 25, 0]
    
    
    var totalAfterTip: Double {
        let tipSelection = Double(tipPercentages[tipPercentage])
        let orderAmount = Double(checkAmount) ?? 0
        
        let tipValue = (orderAmount / 100) * tipSelection
        let grandTotal = orderAmount + tipValue
        
        return grandTotal
    }
    
    var totalPerPerson: Double {
        //let peopleCount = Double(numberOfPeople + 2)
        let peopleCount = Double(Int(numberOfPeople) ?? 2)
        let amountPerPerson = totalAfterTip / peopleCount
        
        return amountPerPerson
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Amount", text: $checkAmount)
                        .keyboardType(.decimalPad)
                    
                    //Picker("Number of people", selection: $numberOfPeople) {
                    //    ForEach(2 ..< 100) {
                    //        Text("\($0) people")
                    //    }
                    //}
                    
                    TextField("Number of people", text: $numberOfPeople)
                        .keyboardType(.numberPad)
                }
                
                Section(header: Text("Tip Percentage")) {
                    Picker("Tip percentage", selection: $tipPercentage) {
                        ForEach(0 ..< tipPercentages.count) {
                            Text("\(tipPercentages[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Total after tip")) {
                    Text("$\(totalAfterTip, specifier: "%.2f")")
                        .foregroundColor(tipPercentages[tipPercentage] == 0 ? .red : .primary)
                }
                
                Section(header: Text("Amount per person")) {
                    Text("$\(totalPerPerson, specifier: "%.2f")")
                }
            }
            .navigationBarTitle("WeSplit")
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
