//
//  MessagesManager.swift
//  ChatApp2
//
//  Created by Consultant on 1/15/23.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class MessagesManager: ObservableObject {
    @Published private(set) var messages: [Messages] = []
    @Published private(set) var lastMessageId = ""
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    // - View propierties
    
    let db = Firestore.firestore()
    
    init (){
        getMessages()
    }

    //MARK: - Get data from Firestore
    
    func getMessages(){
        db.collection("Messages").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(String(describing: error))")
                return
            }
            
            self.messages = documents.compactMap { document -> Messages? in
                do {
                    return try document.data(as: Messages.self)
                } catch {
                    print("Error decoding document into Message: \(error)")
                    return nil
                }
            }
            
            self.messages.sort { $0.timestamp < $1.timestamp}
            
            if let id = self.messages.last?.messageid {
                self.lastMessageId = id
            }
        }
    }
//MARK: -Add data to Firestore
    
    //func sendMessage(text: String, userName: String, userUID:String) {
        func sendMessage(text: String) {
        do{
            
            let newMessages = Messages(id: "\(UUID())", messageid: "\(UUID())" , text: text, timestamp: Date(), userName: userName, userUID: userUID , received: false)
            try db.collection("Messages").document().setData(from: newMessages)
        }catch{
            print("Error adding messages to Firestore: \(error)")
        }
    }
  
    
    
    
    
}
