//
//  User.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 2/2/23.
//

import FirebaseFirestoreSwift
import Firebase

struct User: Identifiable, Decodable{ //this is a user object
    @DocumentID var id: String?
    let username: String
    let fullname: String
    let profileImageUrl: String
    let email: String
    
    var isCurrentUser: Bool {return Auth.auth().currentUser?.uid == id}
}//reading data dictionary looking for exact name, 
