//
//  SessionManager.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/22/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import FirebaseStorage

class SessionManager: ObservableObject{
   // @Published private (set) var profile: [User] = []
    
    init() {
        //self.profile = profile
    }
    
    func logOutUserTest() {
        try? Auth.auth().signOut()
        //ContentView(logStatus: false)
        
    }
    
}
