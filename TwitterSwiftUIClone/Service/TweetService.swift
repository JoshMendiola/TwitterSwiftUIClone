//
//  TweetService.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 2/4/23.
//


//for uploading tweets to firebase
import Firebase

struct TweetService{
    
    func uploadTweet(caption: String, completion: @escaping(Bool) -> Void){ //for uploading tweets
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
    
    func fetchTweets(forUid uid: String, completion: @escaping([Tweet]) -> Void){ //fetches other users' self tweets
        Firestore.firestore().collection("tweets")
            .whereField("uid", isEqualTo: uid)
            .getDocuments{ snapshot, _ in
                guard let documents = snapshot?.documents else {return}
                
                let tweets = documents.compactMap({try? $0.data(as: Tweet.self)})
                completion(tweets.sorted(by: {$0.timestamp.dateValue() > $1.timestamp.dateValue()}))
                
            }
    }
    
}

// MARK: LIKES
extension TweetService{
    
    func likeTweet(_ tweet: Tweet, completion: @escaping() -> Void){
        //print("DEBUG: LIke tweet here...")
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let tweetId = tweet.id else {return}
        
        let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")//firebase collection
        
        Firestore.firestore().collection("tweets").document(tweetId) //goes to firebase collection and updates likes
            .updateData(["likes": tweet.likes + 1]) { _ in
                userLikesRef.document(tweetId).setData([:]) { _ in
                    completion()
                }
            }
    }
    
    func unlikeTweet(_ tweet: Tweet, completion: @escaping() -> Void){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let tweetId = tweet.id else {return}
        guard tweet.likes >= 0 else {return} //makes sure tweets don't go into the negative
        
        let userLikesRef = Firestore.firestore().collection("users").document(uid).collection("user-likes")
        
        Firestore.firestore().collection("tweets").document(tweetId)
            .updateData(["likes": tweet.likes - 1]) { _ in
                userLikesRef.document(tweetId).delete { _ in
                    completion()
                }
            }
    }
    
    func checkIfUserLikedTweet(_ tweet: Tweet, completion: @escaping(Bool) -> Void){//goes to user data and checks user-likes section,
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let tweetId = tweet.id else {return}
        
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-likes")
            .document(tweetId).getDocument { snapshot, _ in
                guard let snapshot = snapshot else {return}
                completion(snapshot.exists) //sees if document exists and if user liked the tweet
            }
    }
    
    func fetchLikedTweets(forUid uid: String, completion: @escaping([Tweet]) -> Void){
        var tweets = [Tweet]()
        print("DEBUG: Fetch LIked tweets here..")
        Firestore.firestore().collection("users")
            .document(uid)
            .collection("user-likes")
            .getDocuments { snapshot, _ in
                guard let documents = snapshot?.documents else {return}
                
                
                documents.forEach{ doc in //goes and fetches document id for user-liked tweets
                    let tweetID = doc.documentID
                    
                    Firestore.firestore().collection("tweets")
                        .document(tweetID)
                        .getDocument { snapshot, _ in
                            guard let tweet = try? snapshot?.data(as: Tweet.self) else {return}
                            tweets.append(tweet)
                            
                            completion(tweets)
                        }
                }
            }
    }
}
