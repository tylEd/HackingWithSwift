//
//  Order.swift
//  Project10_CupcakeCorner
//
//  Created by Tyler Edwards on 10/14/21.
//

import Foundation


class Order: ObservableObject, Codable {
    static let types = ["Vanilla", "Strawberry", "Chocolate", "Rainbow"]
    
    @Published var details = OrderDetails()
    @Published var delivery = DeliveryDetails()

    init() {}
    
    //MARK: Codable
    
    enum CodingKeys: CodingKey {
        case details, delivery
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        details = try container.decode(OrderDetails.self, forKey: .details)
        delivery = try container.decode(DeliveryDetails.self, forKey: .delivery)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(details, forKey: .details)
        try container.encode(delivery, forKey: .delivery)
    }
}


struct OrderDetails: Codable {
    var type = 0
    var quantity = 3
    
    var specialRequestEnabled = false {
        didSet {
            if specialRequestEnabled == false {
                extraFrosting = false
                addSprinkles = false
            }
        }
    }
    var extraFrosting = false
    var addSprinkles = false
    
    var cost: Double {
        var cost = Double(quantity) * 2
        cost += Double(type) / 2
        
        if extraFrosting {
            cost += Double(quantity)
        }
        
        if addSprinkles {
            cost += Double(quantity) / 2
        }
        
        return cost
    }
}


struct DeliveryDetails: Codable {
    var name = ""
    var streetAdress = ""
    var city = ""
    var zip = ""
    
    var hasValidAddress: Bool {
        if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || streetAdress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || zip.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        {
            return false
        }
        
        return true
    }
}
