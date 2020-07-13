//
//  ProfileView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/13/20.
//

import SwiftUI

/// The view for displaying profiles.
struct ProfileView: View {
    
    @State var editable: Bool = false
    @State var account: Account? = nil
    
    var body: some View {
        VStack(alignment: .leading) {
            Image("sotogrande")
                .resizable()
                .frame(height: 264)
            
            VStack(alignment: .leading) {
                Image("pointFlash")
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 100, height: 100)
                    .background(
                        Circle()
                            .frame(width: 110, height: 110)
                            .foregroundColor(.white)
                    )
                Text("Point Flash")
                    .font(.title)
                    .bold()
                Text("@iamnotabug")
                    .font(.callout)
                    .foregroundColor(.secondary)
                Text("Photographer for @ScotiaNews.")
                HStack(spacing: 16.0) {
                    if editable {
                        Button(action: {}) {
                            Label("Edit", systemImage: "square.and.pencil")
                        }
                    } else {
                        Button(action: {}) {
                            Label("Follow", systemImage: "person.badge.plus")
                        }
                    }
                    Button(action: {}) {
                        Label("Mention", systemImage: "bubble.left")
                    }
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "ellipsis.circle")
                    }
                    .contextMenu {
                        Button(action: {}) {
                            Label("Share", systemImage: "square.and.arrow.up")
                        }
                        Button(action: {}) {
                            Label("Show more info", systemImage: "tablecells")
                        }
                        
                        if !editable {
                            Button(action: {}) {
                                Label("Block @iamnotabug", systemImage: "person.crop.circle.fill.badge.xmark")
                            }
                            Button(action: {}) {
                                Label("Report @iamnotabug", systemImage: "hand.raised.fill")
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            .offset(y: -64)
            
            List {
                Text("Statuses for this profile go here.")
            }
            .listStyle(PlainListStyle())
        }
        .edgesIgnoringSafeArea(.top)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
