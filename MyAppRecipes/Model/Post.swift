//
//  Post.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/23/23.
//

import Foundation
import FirebaseFirestoreSwift
import SwiftUI

//MARK: Post Model
struct Post: Identifiable, Codable, Equatable, Hashable{
    
    @DocumentID var id: String?
    var title: String
    var text: String
    var imageURL: URL?
    var imageReferenceID: String = ""
    var publishedDate: Date = Date()
    var likedID: [String] = []
    var dislikedID: [String] = []
    //MARK: Basic User info
    var userName: String
    var userUID: String
    var userProfileURL: URL
    
    enum CodingKeys: CodingKey {
        case id
        case title
        case text
        case imageURL
        case imageReferenceID
        case publishedDate
        case likedID
        case dislikedID
        case userName
        case userUID
        case userProfileURL
    }
    
}
