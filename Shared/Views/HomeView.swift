//
//  HomeView.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/13/20.
//

import SwiftUI

struct HomeView: View {

    @State var showComposeButton: Bool = false
    @State var loggedIn: Bool = false
    @State var showingLogin: Bool = false

    var body: some View {
        NavigationView {
            Group {
                if loggedIn {
                    List {
                        Text("Statuses go here.")
                    }
                    .listStyle(GroupedListStyle())
                } else {
                    loginPrompt
                        .sheet(isPresented: $showingLogin) {
                            LoginView()
                        }
                }
            }
            .navigationTitle("Home")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .primaryAction) {
                    NavigationLink(
                        destination: NotificationsView()) {
                        Image(systemName: "bell")
                            .imageScale(.large)
                    }
                    .help("View all of your notifications.")
                }
                #endif
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showComposeButton = true
            }
        }
        .onDisappear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showComposeButton = false
            }
        }
        .overlay(
            self.composeButton
                .padding()
                .help("Create a new post."),
            alignment: .bottomTrailing)
    }

    var composeButton: some View {

        Button(action: {}, label: {
            Image(systemName: "square.and.pencil")
                .padding()
        })
            .foregroundColor(.white)
            .background(
                Circle()
                    .foregroundColor(.accentColor)
            )
            .offset(x: self.showComposeButton ? 0 : -99999)
            .animation(.spring())

    }

    var loginPrompt: some View {
        List {
            VStack {
                HStack {
                    Image(systemName: "person.crop.circle.fill.badge.plus")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 56)
                    VStack(spacing: 4) {
                        VStack(alignment: .leading) {
                            Text("It's lonely here...")
                                .bold()
                            Text("Sign in to view your personal feed.")
                        }
                    }
                }
                Button(action: { self.showingLogin.toggle() }) {
                    Text("Sign in")
                }
            }
            .background(Color.init(.white))
            .padding(4)
        }
        .listStyle(InsetGroupedListStyle())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
