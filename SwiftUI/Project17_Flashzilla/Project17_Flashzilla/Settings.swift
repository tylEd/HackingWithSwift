//
//  Settings.swift
//  Project17_Flashzilla
//
//  Created by Tyler Edwards on 10/21/21.
//

import SwiftUI

struct Settings: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var retry: Bool
    
    var body: some View {
        NavigationView {
            Form {
                Toggle("Retry Failed Cards", isOn: $retry)
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(retry: .constant(true))
    }
}
