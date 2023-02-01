//
//  MainMessagesViewModel.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/29/23.
//
//
import Foundation
import Firebase

class MainMessagesViewModel: ObservableObject {
    
    //@Published var errorMessages = ""
    
    init () {
        fetchCurrentUser()
    }
    
    private func fetchCurrentUser(){
        //self.errorMessages = "Fetching current user"
        
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {return}
        FirebaseManager.shared.firestore.collection("Users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user: ", error)
                return
            }
            guard let data = snapshot?.data() else { return }
            print(data)
        }
        
        
    }
}
