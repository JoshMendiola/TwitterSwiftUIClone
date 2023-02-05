//
//  SideMenuView.swift
//  TwitterSwiftUIClone
//
//  Created by Ryan Aparicio on 1/30/23.
//

import SwiftUI
import Kingfisher

struct SideMenuView: View {
    @EnvironmentObject var authViewModel: AuthViewModel//current user info comes from here
    
    var body: some View {
        
        if let user = authViewModel.currentUser{
            VStack(alignment: .leading,spacing: 32) {
                //header
                VStack(alignment: .leading){
                    KFImage(URL(string: user.profileImageUrl))//King fisher to image
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width:48, height: 48)
                    
                    VStack(alignment: .leading, spacing: 4){
                        Text(user.fullname)
                            .font(.headline)
                        
                        Text("@\(user.username)")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    UserStatsView()
                    
                }
                .padding(.leading)
                
                ForEach(SideMenuViewModel.allCases, id: \.self){ viewModel in
                    if viewModel == .profile{
                        NavigationLink{
                            ProfileView(user: user)
                        }label:{
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                    }else if viewModel == .logout {
                        Button {
                            //signs user out
                            authViewModel.signOut()
                        } label: {
                            SideMenuOptionRowView(viewModel: viewModel)
                        }
                        
                    }else{
                        SideMenuOptionRowView(viewModel: viewModel)
                        
                    }
                    
                }
                
                Spacer()
            }
        }
    }

}

struct SideMenuView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuView()
    }
}


