//
//  ContentView.swift
//  Project12_CoreData
//
//  Created by Tyler Edwards on 10/16/21.
//

import SwiftUI
import CoreData


//MARK: \.self needs to be hashable

struct Student: Hashable {
    let name: String
}

struct DotSelf_ContentView: View {
    let students = [Student(name: "Harry Potter"), Student(name: "Hermione Granger")]
    var body: some View {
        List {
            ForEach(students, id: \.self) { student in
                Text(student.name)
            }
        }
    }
}


//MARKK: Conditional saving with moc.hasChanges

struct HasChanges_ContentView: View {
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        Button("Save") {
            if moc.hasChanges {
                try? moc.save()
            }
        }
    }
}


//MARK: Constraints

struct Constraints_ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Wizard.entity(), sortDescriptors: []) var wizards: FetchedResults<Wizard>
    
    var body: some View {
        VStack {
            List(wizards, id: \.self) { wizard in
                Text(wizard.name ?? "Unknown name")
            }
            
            Button("Add") {
                let harry = Wizard(context: moc)
                harry.name = "Harry Potter"
            }
            
            Button("Save") {
                do {
                    try moc.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}


//MARK: Filtering with NSPredicate

struct Filtering_ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Ship.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "universe in %@", ["Aliens", "Firefly", "Star Trek"])
    ) var ships: FetchedResults<Ship>
    
    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }
            
            Button("Add Examples") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"
                
                let ship2 = Ship(context: moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"
                
                let ship3 = Ship(context: moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"
                
                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"
                
                try? moc.save()
            }
        }
    }
}


//MARK: Dynamic Filtering

struct /*DynamicFiltering_*/ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @State var lastNameFilter = "A"
    
    var body: some View {
        VStack {
            FilteredList(filterKey: "lastName",
                         filterValue: lastNameFilter,
                         sortDescriptors: [NSSortDescriptor(key: "firstName", ascending: false)],
                         predicateType: .contains)
            { (singer: Singer) in
                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
            }
            
            Button("Add Examples") {
                let s1 = Singer(context: moc)
                s1.firstName = "Taylor"
                s1.lastName = "Swift"
                
                let s2 = Singer(context: moc)
                s2.firstName = "Ed"
                s2.lastName = "Sheeran"
                
                let s3 = Singer(context: moc)
                s3.firstName = "Adele"
                s3.lastName = "Adkins"
                
                try? moc.save()
            }
            
            Button("Show A") {
                lastNameFilter = "A"
            }
            
            Button("Show S") {
                lastNameFilter = "S"
            }
        }
    }
}

struct FilteredList<T: NSManagedObject, Content: View>: View {
    enum PredicateType: String {
        case beginsWith = "BEGINSWITH"
        case contains = "CONTAINS[c]"
        case containsCaseSensitive = "CONTAINS"
    }
    
    var fetchRequest: FetchRequest<T>
    var objects: FetchedResults<T> {
        fetchRequest.wrappedValue
    }
    let content: (T) -> Content

    init(filterKey: String,
         filterValue: String,
         sortDescriptors: [NSSortDescriptor] = [],
         predicateType: PredicateType = .beginsWith,
         content: @escaping (T) -> Content)
    {
        self.content = content
        fetchRequest =
            FetchRequest<T>(entity: T.entity(),
                            sortDescriptors: sortDescriptors,
                            predicate: NSPredicate(format: "%K \(predicateType.rawValue) %@", filterKey, filterValue))
    }
    
    var body: some View {
        List(objects, id: \.self) { object in
            content(object)
        }
    }
}


//MARK: One-to-many relationships

struct OneToMany_ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Country.entity(), sortDescriptors: []) var countries: FetchedResults<Country>
    
    var body: some View {
        VStack {
            List {
                ForEach(countries, id: \.self) { country in
                    Section(header: Text(country.wrappedFullName)) {
                        ForEach(country.candyArray, id: \.self) { candy in
                            Text(candy.wrappedName)
                        }
                    }
                }
            }
            
            Button("Add Examples") {
                let c1 = Candy(context: moc)
                c1.name = "Mars"
                c1.origin = Country(context: moc)
                c1.origin?.shortName = "UK"
                c1.origin?.fullName = "United Kingdom"
                
                let c2 = Candy(context: moc)
                c2.name = "KitKat"
                c2.origin = Country(context: moc)
                c2.origin?.shortName = "UK"
                c2.origin?.fullName = "United Kingdom"
                
                let c3 = Candy(context: moc)
                c3.name = "Twix"
                c3.origin = Country(context: moc)
                c3.origin?.shortName = "UK"
                c3.origin?.fullName = "United Kingdom"
                
                let c4 = Candy(context: moc)
                c4.name = "Toblerone"
                c4.origin = Country(context: moc)
                c4.origin?.shortName = "CH"
                c4.origin?.fullName = "Switzerland"
                
                try? moc.save()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
