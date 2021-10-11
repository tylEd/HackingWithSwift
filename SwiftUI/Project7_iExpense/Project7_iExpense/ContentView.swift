//
//  ContentView.swift
//  Project7_iExpense
//
//  Created by Tyler Edwards on 10/11/21.
//

import SwiftUI

struct ExpenseItem: Identifiable, Codable {
    let id = UUID()
    
    let name: String
    let type: String
    let amount: Int
    
    enum CodingKeys: CodingKey {
        case name
        case type
        case amount
    }
}

class Expenses: ObservableObject {
    @Published var items = [ExpenseItem]() {
        didSet {
            let encoder = JSONEncoder()
            if let itemData = try? encoder.encode(items) {
                UserDefaults.standard.set(itemData, forKey: "Items")
            }
        }
    }
    
    init() {
        if let itemData = UserDefaults.standard.data(forKey: "Items") {
            let decoder = JSONDecoder()
            
            if let items = try? decoder.decode([ExpenseItem].self, from: itemData) {
                self.items = items
                return
            }
        }
        
        self.items = []
    }
}

struct ContentView: View {
    @ObservedObject var expenses = Expenses()
    @State private var showingAddExpense = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(expenses.items) { item in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(item.name)
                                .font(.headline)
                            Text(item.type)
                        }
                        
                        Spacer()
                        
                        Text("$\(item.amount)")
                            .amountFontStyle(amount: item.amount)
                    }
                }
                .onDelete(perform: removeItems) //NOTE: Only available on ForEach
            }
            .navigationBarTitle("iExpense")
            .navigationBarItems(leading:
                                    EditButton(),
                                trailing:
                                    Button(action: {
                                        self.showingAddExpense = true
                                    }){
                                        Image(systemName: "plus")
                                    })
        }
        .sheet(isPresented: $showingAddExpense) {
            AddView(expenses: self.expenses)
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        expenses.items.remove(atOffsets: offsets)
    }
}

struct AmountStyle: ViewModifier {
    var amount: Int
    
    func body(content: Content) -> some View {
        if amount < 10 {
            content
                .font(.caption)
                .foregroundColor(.green)
        } else if amount < 100 {
            content
                .font(.body)
        } else {
            content
                .font(.headline)
                .foregroundColor(.red)
        }
    }
}

extension Text {
    func amountFontStyle(amount: Int) -> some View {
        self.modifier(AmountStyle(amount: amount))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
