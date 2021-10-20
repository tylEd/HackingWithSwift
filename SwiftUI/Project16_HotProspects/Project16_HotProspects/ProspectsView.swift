//
//  ProspectsView.swift
//  Project16_HotProspects
//
//  Created by Tyler Edwards on 10/20/21.
//

import SwiftUI
import CodeScanner
import UserNotifications

struct ProspectsView: View {
    @EnvironmentObject var prospects: Prospects
    @State private var isShowingScanner = false
    @State private var isShowingSortActions = false
    
    enum FilterType {
        case none, contacted, uncontacted
    }
    
    enum SortType {
        case name, mostRecent
    }
    
    let filter: FilterType
    @State private var sort = SortType.mostRecent
    
    var title: String {
        switch filter {
        case .none:
            return "Everyone"
        case .contacted:
            return "Contacted people"
        case .uncontacted:
            return "Uncontacted people"
        }
    }
    
    var filteredAndSortedProspects: [Prospect] {
        let filtered: [Prospect]
        
        switch filter {
        case .none:
            filtered = prospects.people
        case .contacted:
            filtered = prospects.people.filter { $0.isContacted }
        case .uncontacted:
            filtered = prospects.people.filter { !$0.isContacted }
        }
        
        switch sort {
        case .mostRecent:
            return filtered
        case .name:
            return filtered.sorted { $0.name < $1.name }
        }
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(filteredAndSortedProspects) { prospect in
                    HStack {
                        if filter == .none {
                            Image(systemName: prospect.isContacted ? "checkmark.circle.fill" : "xmark.circle.fill")
                        }
                        
                        VStack(alignment: .leading) {
                            Text(prospect.name)
                                .font(.headline)
                            Text(prospect.emailAddress)
                                .foregroundColor(.secondary)
                        }
                    }
                    .contextMenu {
                        Button(prospect.isContacted ? "Mark Uncontacted" : "Mark Contacted") {
                            prospects.toggle(prospect)
                        }
                        
                        if !prospect.isContacted {
                            Button("Remind me") {
                                addNotification(for: prospect)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle(title)
            .navigationBarItems(
                leading:
                    Button("Sort") {
                        isShowingSortActions = true
                    },
                trailing:
                    Button(action: {
                        isShowingScanner = true
                    }) {
                        Image(systemName: "qrcode.viewfinder")
                        Text("Scan")
                    })
            .sheet(isPresented: $isShowingScanner) {
                CodeScannerView(codeTypes: [.qr], simulatedData: "Paul\npaul@hws.com", completion: handleScan)
            }
            .actionSheet(isPresented: $isShowingSortActions) {
                ActionSheet(title: Text("Select Sort Criteria"), message: nil,
                            buttons: [
                                .default(Text("Name")) { sort = .name },
                                .default(Text("Most Recent")) { sort = .mostRecent },
                                .cancel()
                            ])
            }
        }
    }
    
    func handleScan(result: Result<String, CodeScannerView.ScanError>) {
        isShowingScanner = false
        
        switch result {
        case .success(let code):
            let details = code.components(separatedBy: "\n")
            guard details.count == 2 else { return }
            
            let person = Prospect()
            person.name = details[0]
            person.emailAddress = details[1]
            self.prospects.add(person)
            
        case .failure(let error):
            print("Scanning failed: \(error.localizedDescription)")
        }
    }
    
    func addNotification(for prospect: Prospect) {
        let center = UNUserNotificationCenter.current()
        
        let addRequest = {
            let content = UNMutableNotificationContent()
            content.title = "Contact \(prospect.name)"
            content.subtitle = prospect.emailAddress
            content.sound = UNNotificationSound.default
            
            //var dateComponents = DateComponents()
            //dateComponents.hour = 9
            //let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
        
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .authorized {
                addRequest()
            } else {
                center.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                    if success {
                        addRequest()
                    } else {
                        print("Doh")
                    }
                }
            }
        }
    }
}

struct ProspectsView_Previews: PreviewProvider {
    static var previews: some View {
        ProspectsView(filter: .none)
            .environmentObject(Prospects())
    }
}
