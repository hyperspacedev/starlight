//
//  ProfileView.swift
//  Starlight
//
//  Created by Marquis Kurt on 25/9/21.
//

import SwiftUI
import Chica
import StylableScrollView

struct ProfileView: View, InternalStateRepresentable {
    
    enum ProfileContext {
        case currentUser
        case user(id: String)
    }
    
    var context: ProfileContext
    
    @State var state: ViewState = ViewState.initial
    @State private var account: Account?
    
    var body: some View {
        StylableScrollView(.vertical) {
            VStack {
                Text("misc.placeholder")
            }
        }
        .onAppear {
            loadData()
        }
        .scrollViewStyle(
            StretchableScrollViewStyle(
                header: {
                    accountHeader
                },
                title: {
                    HStack {
                        ProfileImage(for: .currentUser)
                        VStack(alignment: .leading) {
                            Text(account?.getName().emojified() ?? "")
                                .font(.system(.title, design: .rounded))
                                .bold()
                                .shadow(color: .black, radius: 4)
                            Text("@\(account?.acct ?? "")")
                                .bold()
                                .shadow(color: .black, radius: 2)
                        }
                        .foregroundColor(.white)
                        Spacer()
                    }
                },
                navBarContent: { Text(account?.getName().emojified() ?? "misc.placeholder") }
            )
        )
    }
    
    private var accountHeader: some View {
        AsyncImage(url: URL(string: account?.headerStatic ?? "")) { phase in
            switch phase {
            case .success(let header):
                header.resizable().scaledToFill()
            case .empty, .failure:
                Color.accentColor
            @unknown default:
                Color.accentColor
            }
        }
    }
    
    internal func loadData() {
        Task.init {
            state = .loading
            do {
                try await getAccountData()
                state = .loaded
            } catch {
                state = .errored(reason: "Unknown error")
            }
        }
    }
    
    private func getAccountData() async throws {
        switch context {
        case .currentUser:
            account = try await Chica.shared.request(.get, for: .verifyAccountCredentials)
        case .user(let id):
            account = try await Chica.shared.request(.get, for: .account(id: id))
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(context: .currentUser)
    }
}
