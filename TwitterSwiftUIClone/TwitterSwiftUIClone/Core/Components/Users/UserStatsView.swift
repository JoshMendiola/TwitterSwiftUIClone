//
//  UserStatsView.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 1/30/23.
//

import SwiftUI

struct UserStatsView: View {
    var body: some View {
        HStack(spacing: 24){
            HStack{
                Text("607")
                    .font(.subheadline)
                    .bold()
                    .padding(.vertical)
                
                Text("Following")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            
            
            HStack{
                Text("6.9M")
                    .font(.subheadline)
                    .bold()
                
                Text("Followers")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }

    }
}

struct UserStatsView_Previews: PreviewProvider {
    static var previews: some View {
        UserStatsView()
    }
}
