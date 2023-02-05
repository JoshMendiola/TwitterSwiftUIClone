//
//  UserService.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 2/2/23.
//

import Firebase
import FirebaseFirestoreSwift
import FirebaseStorage

struct UserService{
    
    func fetchUser(withUid uid: String, completion: @escaping(User)->Void){
        //print("DEBUG: Fetch user info")
        Firestore.firestore().collection("users")
            .document(uid)
            .getDocument { snapshot, _ in
                guard let snapshot = snapshot else {return}
                
                guard let user = try? snapshot.data(as: User.self) else {return} //fetching info from database
                
                completion(user)
            }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void){
        var users = [User]()
        Firestore.firestore().collection("users")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {return}
                
                
                documents.forEach { document in
                    guard let user = try? document.data(as: User.self) else {return}
                    users.append(user)
                }
                completion(users)
            }
    }
}
