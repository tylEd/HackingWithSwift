//
//  AddView.swift
//  Project7_iExpense
//
//  Created by Tyler Edwards on 10/11/21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var expenses: Expenses
    
    @State private var name = ""
    @State private var type = "Personal"
    @State private var amount = ""
    static let types = ["Business", "Personal"]
    
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $name)
                
                Picker("Type", selection: $type) {
                    ForEach(Self.types, id: \.self) {
                        Text($0)
                    }
                }
                
                TextField("Amount", text: $amount)
                    .keyboardType(.numberPad)
            }
            .navigationBarTitle("Add new expense")
            .navigationBarItems(trailing:
                                    Button("Save") {
                                        if let actualAmount = Int(self.amount) {
                                            let item = ExpenseItem(name: name, type: type, amount: actualAmount)
                                            expenses.items.append(item)
                                            presentationMode.wrappedValue.dismiss()
                                        } else {
                                            showingAlert = true
                                        }
                                    })
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Invalid amount"),
                  message: Text("Amount must be an integer value"),
                  dismissButton: .default(Text("OK")))
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static var previews: some View {
        AddView(expenses: Expenses())
    }
}
