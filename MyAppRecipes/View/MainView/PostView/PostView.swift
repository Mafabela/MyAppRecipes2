//
//  PostView.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/23/23.
//

import SwiftUI

struct PostView: View {
    @State private var createNewPost: Bool = false
    @State private var recentPosts: [Post] = []
    var body: some View {
        NavigationStack{
            ContainerPostViews(posts: $recentPosts)
            
                .hAlign(.center).VAlign(.center)
                .overlay(alignment: .bottomTrailing) {
                    Button{
                        createNewPost.toggle()
                    }label: {
                        Image(systemName: "plus.app.fill")
                            .font(.title2)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .padding(13)
                            .background(.orange, in:Circle())
                    }
                    .padding()
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NavigationLink{
                            SerchUserView()
                        } label:{
                            Image(systemName: "magnifyingglass.circle.fill")
                                .tint(.black)
                                .scaleEffect()
                        }
                    }
                })
                .navigationTitle("Post's ")
                .background(LinearGradient(colors: [Color("Peach2"), Color("Peach"), .white], startPoint: .bottomLeading, endPoint: .topTrailing)
                    .edgesIgnoringSafeArea(.all))
        }
        .fullScreenCover(isPresented: $createNewPost) {
                NewPost { post in
                    // Adding last post created on Top
                    recentPosts.insert(post, at: 0)
                }
            }
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
