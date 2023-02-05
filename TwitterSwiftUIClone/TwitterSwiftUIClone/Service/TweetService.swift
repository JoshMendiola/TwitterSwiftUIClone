//
//  TweetService.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 2/4/23.
//


//for uploading tweets to firebase
import Firebase

struct TweetService{
    
    func uploadTweet(caption: String, completion: @escaping(Bool) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return} //to get information about user who uploaded tweet
        
        let data = ["uid": uid,
                    "caption": caption,
                    "likes": 0,
                    "timestamp": Timestamp(date: Date())] as [String : Any]
        
        Firestore.firestore().collection("tweets").document()
            .setData(data){error in
                if let error = error{
                    print("DEBUG: Failed to upload tweet with error: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    
    //gets all tweets to show
    func fetchTweets(completion: @escaping([Tweet]) -> Void){
        Firestore.firestore().collection("tweets")
            .order(by: "timestamp", descending: true)//sorts tweets in the backend to save battery life and improve performance
            .getDocuments{ snapshot, _ in
                guard let documents = snapshot?.documents else {return}
                
                let tweets = documents.compactMap({try? $0.data(as: Tweet.self)})
                completion(tweets)
                
            }
    }
    
    func fetchTweets(forUid uid: String, completion: @escaping([Tweet]) -> Void){ //fetches self tweets
        Firestore.firestore().collection("tweets")
            .whereField("uid", isEqualTo: uid)
            .getDocuments{ snapshot, _ in
                guard let documents = snapshot?.documents else {return}
                
                let tweets = documents.compactMap({try? $0.data(as: Tweet.self)})
                completion(tweets.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()}))
                
            }
    }
}
