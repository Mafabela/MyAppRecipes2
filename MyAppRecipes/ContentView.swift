//
//  ContentView.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/21/23.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("log_status") var logStatus: Bool = false
    var body: some View {
        //LoginView()
        //MARK: Redirecting User Based on LogStatus
        if logStatus {
            //Text("Main View")
            MainView()
        }else{
            LoginView()
        }
//        NewPost { _ in
//
//        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
