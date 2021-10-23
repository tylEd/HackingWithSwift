//
//  ContentView.swift
//  Project19_SnowSeeker
//
//  Created by Tyler Edwards on 10/23/21.
//

import SwiftUI


struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")

    @ObservedObject var favorites = Favorites()
    
    // Filtering and Sorting
    enum SortType { case alphabetical, country }
    @State private var sort: SortType?
    @State private var showingSortSelect = false
    
    @State private var filters = Filters()
    @State private var showingFiltersForm = false
    
    var sortedAndFilteredResorts: [Resort] {
        let filteredResorts = resorts.filter(filters.contains)
        
        if let sort = sort {
            switch sort {
            case .alphabetical:
                return filteredResorts.sorted(by: { $0.name < $1.name })
            case .country:
                return filteredResorts.sorted(by: { $0.country < $1.country })
            }
        } else {
            return filteredResorts
        }
    }

    var body: some View {
        NavigationView {
            List(sortedAndFilteredResorts) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)

                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationBarTitle("Resorts")
            .navigationBarItems(leading: leadingItems, trailing: trailingItems)

            WelcomeView()
        }
        .environmentObject(favorites)
        .actionSheet(isPresented: $showingSortSelect) {
            ActionSheet(title: Text("Sort"), message: nil, buttons: [
                .default(Text("Alphabetical")) { sort = .alphabetical},
                .default(Text("By Country")) { sort = .country },
                .default(Text("Default")) { sort = nil},
                .cancel()
            ])
        }
        .sheet(isPresented: $showingFiltersForm) {
            FiltersView(filters: $filters)
        }
    }
    
    var leadingItems: some View {
        EmptyView()
    }
    
    var trailingItems: some View {
        HStack {
            Button("Filter") {
                showingFiltersForm = true
            }
            
            Button("Sort") {
                showingSortSelect = true
            }
        }
    }
}


extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
