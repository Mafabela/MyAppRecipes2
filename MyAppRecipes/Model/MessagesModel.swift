//
//  MessagesModel.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/29/23.
//

import Foundation
import FirebaseFirestoreSwift


struct Messages: Identifiable, Codable, Equatable, Hashable{
    
    @DocumentID var id: String?
    var messageid: String
    var text: String
    var timestamp: Date = Date()
    //MARK: Basic User info
    var userName: String
    var userUID: String
    //var userProfileURL: URL
    var received: Bool
    
    enum CodingKeys: CodingKey {
        case id
        case messageid
        case text
        case timestamp
        case userName
        case userUID
        //case userProfileURL
        case received
    }
    
}
