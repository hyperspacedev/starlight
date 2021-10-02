//
//  HomeView.swift
//  HomeView
//
//  Created by Marquis Kurt on 27/7/21.
//

import SwiftUI
import StylableScrollView

/// The page for the home view on iOS.
struct HomeView: View {
    var body: some View {
        NavigationView {
            StylableScrollView(.vertical, showIndicators: false) {
                TimelineScrollViewCompatible(scope: .home)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal)
            }
            .scrollViewStyle(
                StretchableScrollViewStyle(
                    header: {
                        Color.accentColor
                            .opacity(0.75)
                    },
                    title: {
                        header
                    },
                    navBarContent: {
                        HStack {
                            Text("tabs.home")
                                .font(.title)
                                .bold()
                            Spacer()
                            NavigationLink(destination: ProfileView(context: .currentUser)) {
                                ProfileImage(for: .currentUser, size: .small)
                            }
                        }
                        .padding(.horizontal)
                    },
                    false
            ))
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
                    .foregroundColor(.white)
                    .bold()
            }
            Spacer()
            NavigationLink(destination: ProfileView(context: .currentUser)) {
                ProfileImage(for: .currentUser, size: .medium)
            }
        }
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
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
