//
//  RegisterView.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/22/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

//MARK: Register View
struct RegisterView: View {
    //MARK: User Details
    @State var emailID: String = ""
    @State var password: String = ""
    @State var userName: String = ""
    @State var userBio: String = ""
    @State var userBioLink: String = ""
    @State var userProfilesPicture: Data?
    //MARK: View Properties
    @Environment(\.dismiss) var dismiss
    @State var showImagePicker: Bool = false
    @State var photoItem: PhotosPickerItem?
    @State var showError: Bool = false
    @State var errorMessage: String = ""
    @State var isLoading: Bool =  false
    //MARK: UserDefaults
    @AppStorage("log_status") var logStatus: Bool = false
    @AppStorage("user_profile_url") var profileURL: URL?
    @AppStorage("user_name") var userNameStored: String = ""
    @AppStorage("user_UID") var userUID: String = ""
    
    var body: some View{
        ZStack {
            LinearGradient(colors: [.orange, Color("Peach"), .white], startPoint: .bottom, endPoint: .top)
                .edgesIgnoringSafeArea(.all)
            //Circle()
                
            VStack(spacing:10){
                Text("Register \nAccount")
                    .font(.largeTitle.bold())
                    .hAlign(.leading)
                Text ("Hello and welcome! \nPrepare yourself to the most tasty travel!")
                    .font(.title3)
                    .hAlign(.leading)
                
               //Aqui estaba    VStack(spacing: 12)
                //MARK: For Smaller Size Optimization
                ViewThatFits{
                    ScrollView(.vertical, showsIndicators: false){
                        HelperView()
                    }
                    HelperView()
                }

                //MARK: Register button
                HStack{
                    Text("Already have an account")
                        .foregroundColor(.gray)
                        .fontWeight(.semibold)
                    Button("Login Now"){
                        dismiss()
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
            
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            .onChange(of: photoItem) { newValue in
                //MARK: Extracting UIImage From PhoroItem
                if let newValue {
                    Task{
                        do{
                            guard let imageData = try await newValue.loadTransferable(type: Data.self) else {return}
                            //MARK: UI must be updated on Main Thread
                            await MainActor.run(body: {
                                userProfilesPicture = imageData
                            })
                        } catch {
                            
                        }
                    }
                }
            }
            
            //MARK: Display alert
        .alert(errorMessage, isPresented: $showError, actions: {})
        }
        //.background(Color(.orange).opacity(0.0))
    }
    
    @ViewBuilder
    func HelperView() -> some View {
        VStack(spacing: 12){
                ZStack{
                    
                    if let userProfilesPicture, let image = UIImage(data: userProfilesPicture){
                        Image(uiImage: image)
                        //Image("NullProfile")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        Image(systemName:"person.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    }
                }
                .frame(width: 90, height: 90)
                .background(.gray)
                .clipShape(Circle())
                .contentShape(Circle())
                .onTapGesture {
                    showImagePicker.toggle()
                }
            .padding(.top, 15)
            
            TextField("Username", text: $userName)
                .textContentType(.emailAddress)
                .border(1.5, .gray.opacity(0.6))
                .padding(.top, 5)
            TextField("Email", text: $emailID)
                .textContentType(.emailAddress)
                .border(1.5, .gray.opacity(0.6))
                
            SecureField("Password", text: $password)
                .textContentType(.emailAddress)
                .border(1.5, .gray.opacity(0.6))
            Text("*At least 6 characters")
                                .fontWeight(.light)
                                .font(.caption2)
                                .padding(.top, -8)
                                .hAlign(.leading)
                                .foregroundColor(Color(.red))
            TextField("About you", text: $userBio, axis: .vertical)
                .frame(minHeight: 100, alignment: .top)
                .textContentType(.emailAddress)
                .border(1.5, .gray.opacity(0.6))
//            TextField("Bio Link (Optional)", text: $userBioLink)
//                .textContentType(.emailAddress)
//                .border(1, .gray.opacity(0.5))
                
            Button(action: registerUser){
                Text("Sign up")
                    .foregroundColor(.orange)
                    .font(.body.bold())
                    .hAlign(.center)
                    .fillView(.black)
            }
            .disableWithOpacity(userName == "" || userBio == "" || emailID == "" || password == "" || userProfilesPicture == nil)
            .padding(.top, 10)
        }
    }
    
    func registerUser(){
        isLoading = true
        closeKeyboard()
        Task{
            do{
                // Step 1: Creating Firebase Account
                try await Auth.auth().createUser(withEmail: emailID, password: password)
                // Step 2: Uploading Profile Photo into firebase Storage
                guard let userUID = Auth.auth().currentUser?.uid else{return}
                guard let imageData =  userProfilesPicture else {return}
                //let storageRef = Storage.storage()
                let storageRef = Storage.storage().reference().child("Profile_Images").child(userUID)
                let _ = try await storageRef.putDataAsync(imageData)
                // Step 3: Downloading Photo URL
                let dowloadURL = try await storageRef.downloadURL()
                // Step 4: Creating a User Firestore Object
                let user = User(username: userName, userBio: userBio, userBioLink: userBioLink, userUID: userUID, userEmail: emailID, userProfileURL: dowloadURL)
                // Step 5: Saving User Doc into Firestore Database
                let _ = try Firestore.firestore().collection("Users").document(userUID).setData(from: user, completion: { error in
                    if error == nil {
                        print ("Saved Succesfully")
                        userNameStored = userName
                        self.userUID = userUID
                        profileURL = dowloadURL
                        logStatus = true
                        
                        
                    }
                    
                })
            }catch{
                // MARK: Deleting Account In case of Failure
                try await Auth.auth().currentUser?.delete()
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


struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView()
        RegisterView()
    }
}
