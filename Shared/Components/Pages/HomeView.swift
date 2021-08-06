//
//  HomeView.swift
//  HomeView
//
//  Created by Marquis Kurt on 27/7/21.
//

import SwiftUI

/// The page for the home view on iOS.
struct HomeView: View {
    
    var timeline = EmptyView()
    
    var body: some View {
        NavigationView {
            VStack {
                header
            }
            .navigationTitle("tabs.home")
            #if os(iOS)
            .navigationBarHidden(true)
            #endif
        }
    }
    
    var header: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(Date(), style: .date)
                    .font(.system(.headline, design: .rounded))
                    .textCase(.uppercase)
                    .foregroundColor(.secondary)
                Text("tabs.home")
                    .font(.system(.largeTitle, design: .rounded))
                    .bold()
            }
            Spacer()
            NavigationLink(
                destination: Text("misc.placeholder")
                    .navigationTitle("tabs.profile")
            ) {
                ProfileImage(for: .currentUser, size: .medium)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.bar)
    }
}

struct HomeViewButtonRow: View {
    var body: some View {
        VStack {
            Spacer(minLength: 90)
            HStack {
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                        Text("actions.create")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.25))
                    .cornerRadius(6.0)
                }
                Button(action: {}) {
                    VStack(spacing: 4) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.title2)
                        Text("actions.upload")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.secondary.opacity(0.25))
                    .cornerRadius(6.0)
                }
            }
        }
        
        .padding()
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
