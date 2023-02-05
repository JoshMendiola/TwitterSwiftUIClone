//
//  UploadTweetViewModel.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 2/4/23.
//

import Foundation

class UploadTweetViewModel: ObservableObject{
    @Published var didUploadTweet = false
    let service = TweetService()
    
    func uploadTweet(withCaption caption: String){
        service.uploadTweet(caption: caption) { success in
            //dismiss screen
            self.didUploadTweet = true
        }
    }
}
