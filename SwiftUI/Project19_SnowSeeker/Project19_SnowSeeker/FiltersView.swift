//
//  FiltersView.swift
//  Project19_SnowSeeker
//
//  Created by Tyler Edwards on 10/23/21.
//

import SwiftUI


struct FiltersView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var filters: Filters
    
    func size(_ size: Int) -> String {
        switch size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }

    func price(_ price: Int) -> String {
        String(repeating: "$", count: price)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Countries")) {
                    ForEach(Array(Resort.allCountries), id: \.self) { country in
                        Button(action: {
                            filters.toggle(country: country)
                        }) {
                            HStack {
                                Text(country)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: filters.countries.contains(country) ? "checkmark.circle" : "circle")
                            }
                        }
                    }
                }
                
                Section(header: Text("Sizes")) {
                    ForEach(Array(Resort.allSizes), id: \.self) { size in
                        Button(action: {
                            filters.toggle(size: size)
                        }) {
                            HStack {
                                Text(self.size(size))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: filters.sizes.contains(size) ? "checkmark.circle" : "circle")
                            }
                        }
                    }
                }
                
                Section(header: Text("Prices")) {
                    ForEach(Array(Resort.allPrices), id: \.self) { price in
                        Button(action: {
                            filters.toggle(price: price)
                        }) {
                            HStack {
                                Text(self.price(price))
                                    .foregroundColor(.black)
                                
                                Spacer()
                                
                                Image(systemName: filters.prices.contains(price) ? "checkmark.circle" : "circle")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Filters", displayMode: .inline)
            .navigationBarItems(leading: Button("Clear") { filters.clear() },
                                trailing: Button("Done") { presentationMode.wrappedValue.dismiss() })
        }
    }
}


struct FiltersView_Previews: PreviewProvider {
    static var previews: some View {
        FiltersView(filters: .constant(Filters()))
    }
}
