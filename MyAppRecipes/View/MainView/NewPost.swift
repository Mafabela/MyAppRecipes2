//
//  NewPost.swift
//  MyAppRecipes
//
//  Created by Consultant on 1/23/23.
//

import SwiftUI
import PhotosUI
import Firebase
import FirebaseStorage

struct NewPost: View {
    //Callbacks
    var onPost: (Post) -> ()
    // - Post Properties
    @State private var postText: String = ""
    @State private var postTitle: String = ""
    @State private var postImageData: Data?
    // -Stored user Data From UserDefaults (AppStorage) - private
    @AppStorage("user_profile_url") private var profileURL: URL?
    @AppStorage("user_name") private var userName: String = ""
    @AppStorage("user_UID") private var userUID: String = ""
    // - View propierties
    @Environment(\.dismiss) private var dismiss
    @State private var isLoading: Bool = false
    @State private var errorMessage: String = ""
    @State private var showError: Bool = false
    //Image
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @FocusState private var showKeyboard: Bool  //Keyboard On/Off
    var body: some View {
        VStack{
            HStack{
                Menu{
                    Button("Cancel", role: .destructive){
                        dismiss()
                    }
                } label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .hAlign(.leading)
                //.padding(.leading)
                
                Button (action: createPost){
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.orange)
                        .bold()
                        .padding(.horizontal, 20)
                        .padding(.vertical, 6)
                        .background(.black, in: Capsule())
                }
                .disableWithOpacity(postText == "")
                
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 10)
            .background{
                Rectangle()
                    .fill(.yellow.opacity(0.2))
                    .ignoresSafeArea()
            }
//            Title space
            HStack{
                TextField("Title", text: $postTitle)
                    .textContentType(.emailAddress)
                    .border(1, .gray.opacity(0.5))
                    .padding(.horizontal, 3)
            }
            
            
            //Sapace for post
            ScrollView(.vertical, showsIndicators: false){
                VStack (spacing:15){
                    TextField("Share the best food on the world!", text: $postText, axis: .vertical)
                        .focused($showKeyboard)
                    
                    if let postImageData, let image = UIImage(data: postImageData){
                        GeometryReader{
                            let size = $0.size
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                //.foregroundColor(.black)
                                .overlay {
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.15)) {
                                            self.postImageData = nil
                                        }
                                    }label: {
                                        Image(systemName: "trash.circle.fill")
                                            .font(.title)
                                            .foregroundColor(.black)
                                            .background(.white)
                                            .cornerRadius(50)
                                        
                                    }
                                    .padding(10)
                                }
                                
                        }
                        .clipped()
                        .frame(height: 220)
                        //.border(Color.gray)
                    }
                }
                .padding(10)
            }
            Divider()
            HStack{
                Button {
                    showImagePicker.toggle()
                }label: {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                        .font(.title2)
                        //.foregroundColor(.orange)
                }
                .hAlign(.leading)
                
                Button("Done"){
                    showKeyboard = false
                }
                
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 5)
            .foregroundColor(.orange)
            
        }
        .VAlign(.top)
        .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
        .onChange(of: photoItem) { newValue in
            if let newValue{
                Task{
                    if let rawImageData = try? await newValue.loadTransferable(type: Data.self),
                        let image = UIImage(data: rawImageData),
                        let compressed = image.jpegData(compressionQuality: 0.5) { //compress for save storage
                        //UI Must be done on Main Thread
                        await MainActor.run(body: {
                            postImageData = compressed
                            photoItem = nil
                        })
                        
                    }
                }
            }
        }
        .alert(errorMessage, isPresented: $showError, actions: {})
        //Loading View
        .overlay {
            LoadingView(show: $isLoading)
        }
    }
    
    //MARK: Post content to Firebase
    func createPost (){
        isLoading = true
        showKeyboard = false
        Task {
            do{
                guard let profileURL = profileURL else {return}
                // 1- Uploading image if any
                // Also used to delete
                let imageReferenceID = "\(userUID)\(Date())"
                let storageReference = Storage.storage().reference().child("Post_Images").child(imageReferenceID)
                if let postImageData {
                    let _ = try await storageReference.putDataAsync(postImageData)
                    let downloadURL = try await storageReference.downloadURL()
                    
                    // Create Post Object Whit Image Id and URL
                    let post = Post(title: postTitle, text: postText, imageURL: downloadURL, imageReferenceID: imageReferenceID, userName: userName, userUID: userUID, userProfileURL: profileURL)
                    try await createDocumentFirebase(post)
                }else {
                    //Directly post text Data to Firebase (since there is no images present)
                    let post = Post(title: postTitle, text: postText, userName: userName, userUID: userUID, userProfileURL: profileURL)
                    try await createDocumentFirebase(post)
                }
            }catch{
                await setError(error)
            }
        }
    }
    
    func createDocumentFirebase(_ post: Post) async throws{
       // - Writing Document to firebase
        let docs = Firestore.firestore().collection("Posts").document()
        let _ = try docs.setData(from: post,completion: { error in
            if error == nil {
                isLoading = false
                var updatedPost = post
                updatedPost.id = docs.documentID
                onPost(updatedPost)
                dismiss()
            }
        })
    }
    
    func setError(_ error: Error)async{
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
    
}

struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost{_ in
            
        }
    }
}
