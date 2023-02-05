//
//  ProfileViewModel.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 2/5/23.
//

import Foundation

class ProfileViewModel: ObservableObject{
    @Published var tweets = [Tweet]()
    private let service = TweetService()
    let user: User
    
    
    init(user: User){
        self.user = user
        self.fetchUserTweets()
        
    }
    
    func fetchUserTweets(){
        guard let uid = user.id else {return}
        service.fetchTweets(forUid: uid) { tweets in
            self.tweets = tweets
            
            //loop throught tweets and set user properties
            for i in 0 ..< tweets.count{
                self.tweets[i].user = self.user
                
            }
        }
    }
}
