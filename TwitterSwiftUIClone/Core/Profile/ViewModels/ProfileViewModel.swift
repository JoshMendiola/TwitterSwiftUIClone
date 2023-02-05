//
//  ProfileViewModel.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 2/5/23.
//

import Foundation

class ProfileViewModel: ObservableObject{
    @Published var tweets = [Tweet]()
    @Published var likedTweets = [Tweet]()
    
    private let service = TweetService()
    private let userService = UserService()
    let user: User
    
    
    init(user: User){
        self.user = user
        self.fetchUserTweets()
        self.fetchLikedTweets()
        
        
    }
    var actionButtonTitle: String{
        return user.isCurrentUser ? "Edit Profile" : "Follow" //if user = current user edit prof, else follwo
    }
    
    func tweets(forFilter filter: TweetFilterViewModel) -> [Tweet]{
        switch filter{
        case .tweets:
            return tweets
        case .replies:
            return tweets
        case .likes:
            return likedTweets
        }
    }
    
    func fetchUserTweets(){
        guard let uid = user.id else {return} //gets current user's id
        service.fetchTweets(forUid: uid) { tweets in
            self.tweets = tweets
            
            //loop throught tweets and set user properties
            for i in 0 ..< tweets.count{
                self.tweets[i].user = self.user
                
            }
        }
    }
    
    func fetchLikedTweets(){
        guard let uid = user.id else {return}
        
        
        service.fetchLikedTweets(forUid: uid) { tweets in
            self.likedTweets = tweets
            
            
            for i in 0 ..< tweets.count{
                let uid = tweets[i].uid
                
                self.userService.fetchUser(withUid: uid) { user in
                    self.likedTweets[i].user = user
                }
            }
            
        }
    }
}
