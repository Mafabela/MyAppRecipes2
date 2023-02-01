//
//  TitleRow.swift
//  ChatApp2
//
//  Created by Consultant on 1/15/23.
//

import SwiftUI

struct TitleRow: View {
    //var user: User
    @AppStorage("user_name") private var name: String = ""
    //@AppStorage("user_UID") private var userUID: String = ""
    @AppStorage("user_profile_url") private var profileURL: URL?
    // - View propierties
    var imageUrl = URL(string: "https://images.unsplash.com/photo-1466637574441-749b8f19452f?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1480&q=80")
    
    //https://images.unsplash.com/photo-1541779408-c355f91b42c9?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=986&q=80
    
    //var name = "Usuario"
    var body: some View {
        HStack(spacing: 5) {
//            AsyncImage(url: imageUrl) { image in
//                image.resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: 50, height: 50)
//                    .cornerRadius(50)
//            } placeholder: {
//                ProgressView()
//            }
            Image("Logo_MyApp")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 60, height: 50)
                    .cornerRadius(50)
            
            
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title).bold()
                
                Text("Online - Global Chat")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Image (systemName: "message.fill")
                .foregroundColor(.green)
                .padding(10)
                .background(.white)
                .cornerRadius(50)
        }
        .padding()
    }
    
}

struct TitleRow_Previews: PreviewProvider {
    static var previews: some View {
        TitleRow()
            .background(Color("Peach"))
        //ContentViewMessages()
    }
}
