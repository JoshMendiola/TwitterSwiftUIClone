//
//  Tweet.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 2/4/23.
//

import FirebaseFirestoreSwift
import Firebase

struct Tweet: Identifiable, Decodable {
    @DocumentID var id: String?
    let caption: String
    let timestamp: Timestamp
    let uid: String
    var likes: Int
    
    var user: User?
}
