//
//  Learnings.swift
//  BucketList
//
//  Created by Satinder Singh on 29/12/24.
//

import SwiftUI
import LocalAuthentication

struct Learnings: View {
    @State private var isUnloced = false
    
    var body: some View {
        VStack {
            if isUnloced {
                Text("Unlocked")
            } else {
                Text("Locked")
                Button("Unlock", action: authenticate)
            }
        }
        .onAppear(perform: authenticate)
    }
    
    func authenticate() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "We need to unlock your data."
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                if success {
                    isUnloced = true
                } else {
                    //there was problem
                }
            }
        } else {
            print("no biometrics")
        }
    }
}

#Preview {
    Learnings()
}
