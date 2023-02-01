//
//  SerchUserView.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/26/23.
//

import SwiftUI
import FirebaseFirestore


struct SerchUserView: View {
    @State private var fetchedUser: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        List{
            ForEach(fetchedUser) { user in
                
                NavigationLink{
                    ProfileContent(user: user)
                   
                } label: {
                    Text(user.username)
                }
            }
        }
        .navigationTitle("Search User:")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText)
        .onSubmit(of: .search, {
            // Fetch user From Firebase
            Task{
                await searchUser()
            }
        })
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty{
                fetchedUser = []
            }
        })
     

    }
     
    
    //
    func searchUser()async{
        do{
//            let queryLowerCassed = searchText.lowercased()
//            let queryUpperCassed =  searchText.uppercased()
            
            let documents = try await Firestore.firestore().collection("Users").whereField("username", isGreaterThanOrEqualTo: searchText).whereField("username", isLessThanOrEqualTo: "\(searchText)\u{f8ff}").getDocuments()
//                .where('name', '>=', queryText)
//                .where('name', '<=', queryText+ '\uf8ff')
            let users = try documents.documents.compactMap({ doc -> User? in
                try doc.data(as: User.self)
            })
            //UI Must be Updated on Main Thread
            await MainActor.run(body: {
                fetchedUser = users
            })
        }catch {
            print(error.localizedDescription)
        }
    }
    
    
}

struct SerchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SerchUserView()
    }
}
