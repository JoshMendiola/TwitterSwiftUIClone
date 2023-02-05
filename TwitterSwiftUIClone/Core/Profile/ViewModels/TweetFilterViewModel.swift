//
//  TweetFilterViewModel.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 1/30/23.
//

import Foundation

enum TweetFilterViewModel: Int, CaseIterable{//cases for tweet filter
    //allows me to treat all enum cases like an array
    case tweets
    case replies
    case likes
    
    var title: String{
        switch self{
        case .tweets: return "Tweets"
        case .replies: return "Replies"
        case .likes: return "Likes"
        }
    }
}
