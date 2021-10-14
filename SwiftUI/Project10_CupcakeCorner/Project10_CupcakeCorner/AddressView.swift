//
//  AddressView.swift
//  Project10_CupcakeCorner
//
//  Created by Tyler Edwards on 10/14/21.
//

import SwiftUI


struct AddressView: View {
    @ObservedObject var order: Order
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $order.delivery.name)
                TextField("Street Address", text: $order.delivery.streetAdress)
                TextField("City", text: $order.delivery.city)
                TextField("Zip", text: $order.delivery.zip)
            }
            
            Section {
                NavigationLink(destination: CheckoutView(order: order)) {
                    Text("Checkout")
                }
            }
            .disabled(order.delivery.hasValidAddress == false)
        }
        .navigationBarTitle("Delivery Details", displayMode: .inline)
    }
}


struct AddressView_Previews: PreviewProvider {
    static var previews: some View {
        AddressView(order: Order())
    }
}
