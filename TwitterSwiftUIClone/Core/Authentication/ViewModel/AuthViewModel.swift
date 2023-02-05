//
//  AuthViewModel.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 1/31/23.
//

import SwiftUI
import Firebase
import FirebaseStorage
//import FirebaseAnalytics

class AuthViewModel: ObservableObject{
    @Published var userSession: FirebaseAuth.User? // stores user session, if user is logged in
    @Published var didAutheticateUser = false
    @Published var currentUser: User?//optional bc API take time to call, and user info will be nill for a sec
    private var tempUserSession: FirebaseAuth.User?
    
    private let service = UserService()
    
    init(){
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
        
        //print("Debug: User Session is \(String(describing: self.userSession?.uid))")//2:41:35
    }
    
    func login(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error{
                print("DEBUG: failed to login with error \(error.localizedDescription)")
                return
            }
            guard let user = result?.user else {return}
            self.userSession = user
            //print("DEBUG: did log in")
            self.fetchUser()
        }
    }
    
    func register(withEmail email: String, password: String, fullname: String, username: String){
        //print("Register with email \(email)")
        Auth.auth().createUser(withEmail: email, password: password) { result, error in//goes to fire base to create username
            if let error = error{
                print("DEBUG: failed to register with error \(error.localizedDescription)")
                return
            }
            
            guard let user = result?.user else {return}
            //self.userSession = user
            self.tempUserSession = user
            
            
            //dictionary
            let data = ["email": email,
                        "username": username.lowercased(),
                        "fullname": fullname,
                        "uid": user.uid]
            
            Firestore.firestore().collection("users")
                .document(user.uid)
                .setData(data){_ in
                    self.didAutheticateUser = true
                }
        }
        
    }
    func signOut(){
        
        //sets user session to nil so we show login view
        //local var
        userSession = nil
        
        //signs user out from server
        try? Auth.auth().signOut()
    }
    
    func uploadProfileImage(_ image: UIImage){
        guard let uid = tempUserSession?.uid else {return}
        
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl]){_ in
                    self.userSession = self.tempUserSession
                    self.fetchUser()
                }
        }
    }
    
    func fetchUser(){ //calls of service fetch user to get current user uid
        guard let uid = self.userSession?.uid else {return}
        
        service.fetchUser(withUid: uid) { user in
            self.currentUser = user
        }
    }
}
