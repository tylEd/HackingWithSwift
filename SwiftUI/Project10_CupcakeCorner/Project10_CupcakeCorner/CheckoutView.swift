//
//  CheckoutView.swift
//  Project10_CupcakeCorner
//
//  Created by Tyler Edwards on 10/14/21.
//

import SwiftUI


struct CheckoutView: View {
    @ObservedObject var order: Order
    
    @State private var confirmationMsg = ""
    @State private var showingConfirmation = false
    
    @State private var showingError = false
    
    var body: some View {
        GeometryReader { geo in
            ScrollView {
                VStack {
                    Image("cupcakes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: geo.size.width)
                    
                    Text("Your total is $\(self.order.details.cost, specifier: "%.2f")")
                        .font(.title)
                        .alert(isPresented: $showingError) {
                            Alert(title: Text("Oop! Something went wrong."),
                                  message: Text("Check you network connection, and try again in a few seconds."),
                                  dismissButton: .default(Text("OK")))
                        }
                    
                    Button("Place Order") {
                        placeOrder()
                    }
                    .padding()
                    .alert(isPresented: $showingConfirmation) {
                        Alert(title: Text("Thank you!"), message: Text(confirmationMsg), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
        .navigationBarTitle("Checkout", displayMode: .inline)
    }
    
    func placeOrder() {
        guard let encoded = try? JSONEncoder().encode(order) else {
            print("Failed to encode order")
            return
        }
        
        let url = URL(string: "https://reqres.in/api/cupcakes")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = encoded
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unkown error")")
                showingError = true
                return
            }
            
            if let decodedOrder = try? JSONDecoder().decode(Order.self, from: data) {
                self.confirmationMsg = "Your order for \(decodedOrder.details.quantity) \(Order.types[decodedOrder.details.type].lowercased()) cupcakes is on its way!"
                self.showingConfirmation = true
            } else {
                print("Invalid response from server")
                self.showingError = true
            }
        }.resume()
    }
}


struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        CheckoutView(order: Order())
    }
}
