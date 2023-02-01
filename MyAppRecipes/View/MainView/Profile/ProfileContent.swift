//
//  ProfileContent.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/22/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct ProfileContent: View {
    @State private var getPost: [Post] = []
    var user: User
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack{
                HStack(spacing: 12){
                    WebImage(url: user.userProfileURL).placeholder(){
                        Image(systemName: "person.fill")
                            .resizable()
                    }
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    
                    VStack(alignment: .leading, spacing: 10){
                        Text(user.username)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(user.userBio)
                            .font(.callout)
                            .foregroundColor(.gray)
                            .lineLimit(4)
                        
                        //Display Link
//                        if let bioLink = URL(string: user.userBioLink){
//                            Link(user.userBioLink, destination: bioLink)
//                                .font(.callout)
//                                .tint(.blue)
//                                .lineLimit(1)
//                        }
                    }
                    .hAlign(.leading)
                    
                }
                
                Text("Post's")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .hAlign(.leading)
                    .padding(.vertical, 15)
                //ContainerPostViews(posts: $getPost)
                ContainerPostViews(posts: $getPost, userUID: true, uid: user.userUID)
            }
           
            
        }
        .background(LinearGradient(colors: [Color("Peach2"), Color("Peach"), .white], startPoint: .bottomLeading, endPoint: .topTrailing)
            .edgesIgnoringSafeArea(.all))
        
    }
}

//
