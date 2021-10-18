//
//  ContentView.swift
//  Project14_BucketList
//
//  Created by Tyler Edwards on 10/18/21.
//

import SwiftUI
import LocalAuthentication

struct ContentView: View {
    @State private var isUnlocked = false
    
    @State private var errorTitle = ""
    @State private var errorMsg = ""
    @State private var showingErrorAlert = false
    
    var body: some View {
        ZStack {
            if isUnlocked {
                PlacesView()
            } else {
                Button("Unlock Places") {
                    authenticate()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .alert(isPresented: $showingErrorAlert) {
            Alert(title: Text(errorTitle),
                  message: Text(errorMsg),
                  dismissButton: .default(Text("OK")))
        }
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate yourself to unlock your places."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        isUnlocked = true
                    } else {
                         errorTitle = "An Error Occurred"
                         errorMsg = authError?.localizedDescription ?? "Invalid auth"
                         showingErrorAlert = true
                    }
                }
            }
        } else {
            errorTitle = "FaceID Not Enabled"
            errorMsg = "Must have biometric auth enabled to view places."
            showingErrorAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
