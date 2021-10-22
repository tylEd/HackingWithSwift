//
//  SettingsView.swift
//  Project17_Flashzilla
//
//  Created by Tyler Edwards on 10/21/21.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var settings: Settings

    var body: some View {
        NavigationView {
            Form {
                Toggle("Retry Failed Cards", isOn: $settings.retry)
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

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(Settings())
    }
}
