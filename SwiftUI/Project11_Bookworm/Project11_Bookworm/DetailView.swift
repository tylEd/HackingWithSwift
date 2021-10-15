//
//  DetailView.swift
//  Project11_Bookworm
//
//  Created by Tyler Edwards on 10/15/21.
//

import SwiftUI
import CoreData

struct DetailView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    let book: Book
    
    var body: some View {
        GeometryReader { geo in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(book.genre ?? "Fantasy")
                        .frame(maxWidth: geo.size.width)
                    
                    Text(book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                Text(book.author ?? "Unknown author")
                    .font(.title)
                    .foregroundColor(.secondary)
                
                Text(book.review ?? "No review")
                    .padding()
                
                //NOTE: Making the binding a constant prevents the internal interactions in the RatingView
                RatingView(rating: .constant(Int(book.rating)))
                    .font(.largeTitle)
                
                Text("Reviewed on \(formattedDateString())")
                    .font(.caption)
                    .padding()
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown book"), displayMode: .inline)
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Book"),
                  message: Text("Are you sure?"),
                  primaryButton: .destructive(Text("Delete")) {
                    deleteBook()
                  },
                  secondaryButton: .cancel())
        }
        .navigationBarItems(trailing:
                                Button(action: { showingDeleteAlert = true }) {
                                    Image(systemName: "trash")
                                })
    }
    
    func deleteBook() {
        moc.delete(book)
        try? moc.save()
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func formattedDateString() -> String {
        if let date = book.date {
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            return formatter.string(from: date)
        } else {
            return "unknown date"
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    static var previews: some View {
        let book = Book(context: moc)
        book.title = "Test book"
        book.author = "Test author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This is just a test book. Nothing to say here."
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
