//
//  MainView.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/22/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        ZStack {
            
            TabView{
                //Text("Recent Post's")
                PostView()
                    .tabItem{
                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.angled")
                        Text("Post's")
                    }
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.square")
                        Text("Profile")
                    }
                //Text("Messages")
                ContentViewMessages()
                    .tabItem{
                        Image(systemName:"message.circle.fill")
                        Text("Global Messages")
                    }
            }
            
            //Changing Tab Lable Tint to Black
            .tint(.orange)
            //.background(.black)
        }
        
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
        //ContentView()
    }
}
