//
//  LoginView.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/21/23.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage

struct LoginView: View {
    //MARK: UserDetails
    @State var emailID: String = ""
    @State var password: String = ""
    //MARK: View Properties
    @State var createAccount: Bool = false
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool =  false
    //MARK:  User Defaults
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    @AppStorage("log_status") var logStatus: Bool = false
    
    var body: some View {
        ZStack {
            LinearGradient(colors: [Color("Peach2"), Color("Peach"), .white, Color("Peach")], startPoint: .bottom, endPoint: .top)
                .edgesIgnoringSafeArea(.all)
            //Color("Peach2")
//                .ignoresSafeArea()
//                .opacity(0.85)
//            Circle()
//                .scale(1.70)
//                .foregroundColor(Color("Peach2").opacity(0.85))
//            Circle()
//                .scale(1.30)
//                .foregroundColor(.white)
            VStack(spacing:10){
                Text("Lets Sign you in")
                    .font(.largeTitle.bold())
                    .hAlign(.leading)
                Text ("Welcome back, \nYou have been missed")
                    .font(.title3)
                    .hAlign(.leading)
                //Spacer()
                HStack(){
                    Image("Logo_MyApp")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                }
                .frame(width: 320, height: 280)
                //.background(.black)
                
                VStack(spacing: 12){
                    TextField("Email", text: $emailID)
                        .textContentType(.emailAddress)
                        //.border(1, .gray.opacity(0.5))
                        .border(2, .gray)
                        .padding(.top, 25)
                    SecureField("Password", text: $password)
                        .textContentType(.emailAddress)
                        .border(2, .gray)
                        //.border(1, .gray.opacity(0.5))
                    
                    Button ("Reset password", action: resetPassword)
                        .font(.callout)
                        .fontWeight(.medium)
                        .tint(.black)
                        .hAlign(.trailing)
                    Button(action: loginUser){
                        Text("Sign in")
                            .foregroundColor(.black)
                            .font(.body.bold())
                            .hAlign(.center)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 15)
                            .background(LinearGradient(gradient: Gradient(colors: [Color(.systemRed), Color(.systemOrange)]), startPoint: .bottom, endPoint: .top))
                            .cornerRadius(20)
                            //.fillView(.black)
                            
                            //.fillView(LinearGradient(gradient: Gradient(colors: [Color(.systemRed), Color(.systemBlue)]), startPoint: .leading, endPoint: .trailing))
                    }
                    .padding(.top,10)
                    
                }
                
                //MARK: Register button
                HStack{
                    Text("Dont have account")
                        .foregroundColor(.white)
                        .fontWeight(.semibold)
                    Button("Register Now"){
                        createAccount.toggle()
                    }
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                }
                .font(.callout)
                .VAlign(.bottom)
            }
            .VAlign(.top)
            .padding(15)
            .overlay(content: {
                LoadingView(show: $isLoading)
            })
            
            // MARK: Register View VIA Sheets
            .fullScreenCover(isPresented: $createAccount) {
                RegisterView()
            }
            //MARK: Displaying Alert
        .alert(errorMessage, isPresented: $showError, actions: {})
        }
        
    }
    func loginUser(){
        isLoading = true
        closeKeyboard()
        Task {
            do{
                //With the help of Swift Concurrency Auth can be done with SingleLine
                try await Auth.auth().signIn(withEmail: emailID, password: password)
                print("User Found")
                try await fetchUser()
            }catch {
                await setError(error)
            }
        }
    }
    
    //MARK: If User if found then Fetching User Data Firestore
    func fetchUser() async throws{
        guard let userID = Auth.auth().currentUser?.uid else {return}
       let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
        //MARK: UI Updating Must be Run On Main Thread
        await MainActor.run(body: {
            // Setting UserDefaults data and Changing App's Auth Status
            userUID = userID
            userNameStored = user.username
            profileURL = user.userProfileURL
            logStatus = true
        })
    }
    
    
    func resetPassword(){
        Task {
            do{
                //With the help of Swift Concurrency Auth can be done with SingleLine
                try await Auth.auth().sendPasswordReset(withEmail: emailID)
                print("Link Sent")
            }catch {
                await setError(error)
            }
        }
    }
    
    // MARK: Displaying Error VIA Aler
    func setError(_ error: Error)async{
        //Must be update on Main thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
            isLoading = false
        })
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
        //RegisterView()
    }
}
