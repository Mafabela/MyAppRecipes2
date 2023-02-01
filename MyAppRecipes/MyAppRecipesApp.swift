//
//  MyAppRecipesApp.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/21/23.
//

import SwiftUI
import Firebase

@main
struct MyAppRecipesApp: App {
    init () {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
