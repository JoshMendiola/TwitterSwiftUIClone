//
//  TweetRowView.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 1/30/23.
//

import SwiftUI
import Kingfisher

struct TweetRowView: View {
    @ObservedObject var viewModel: TweetRowViewModel //needs to be observed to see changes
    
    init(tweet: Tweet){
        self.viewModel = TweetRowViewModel(tweet: tweet)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            
            //profile image and user info and tweet
            if let user = viewModel.tweet.user{
                HStack(alignment: .top, spacing:12){
                    KFImage(URL(string: user.profileImageUrl))
                        .resizable()
                        .scaledToFill()
                        .frame(width:56, height: 56)
                        .clipShape(Circle())
                    //user info and tweet caption
                    VStack(alignment: .leading, spacing: 4){
                        //user info
                        HStack{
                            Text(user.fullname)
                                .font(.subheadline).bold()
                            
                            Text("@\(user.username)")
                                .foregroundColor(.gray)
                                .font(.caption)
                            
                            Text("2w")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                        
                        
                        //tweet caption
                        Text(viewModel.tweet.caption)
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                    }
                }
            }
            //action buttons
            HStack{
                Button {
                    //action goes here
                } label: {
                    Image(systemName: "bubble.left")
                        .font(.subheadline)
                    
                }
                
                Spacer()
                
                Button {
                    //action goes here
                } label: {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.subheadline)
                    
                }
                
                Spacer()
                
                Button {
                    viewModel.tweet.didLike ?? false ? //if tweet has been liked
                    viewModel.unlikeTweet() : //tweet gets unliked
                    viewModel.likeTweet() //else tweet gets liked
                    
                } label: {
                    Image(systemName: viewModel.tweet.didLike ?? false ? "heart.fill": "heart")
                        .font(.subheadline)
                        .foregroundColor(viewModel.tweet.didLike ?? false ? .red : .gray)
                    
                }
                
                Spacer()
                
                Button {
                    //action goes here
                } label: {
                    Image(systemName: "bookmark")
                        .font(.subheadline)
                    
                }
                
                Spacer()

            }
            .padding()
            .foregroundColor(.gray)
            
            Divider()
        }
    }
}


