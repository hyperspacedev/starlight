//
//  Account.swift
//  Account
//
//  Created by Marquis Kurt on 5/8/21.
//

import Foundation
import Chica

extension Account {
    
    /// Returns the URL to the avatar of the account.
    func getAvatar() -> String {
        self.avatar.isEmpty ? self.avatarStatic : self.avatar
    }
    
    /// Returns the display name of the account, or the user's full username and domain if no display name is set.
    func getName() -> String {
        self.displayName.isEmpty ? "@" + self.acct : self.displayName
    }

    /// Whether the account forms part of the Hyperspacedev team.
    var isDev: Bool {
        if self.id == "380904" || self.id == "329742" {
            return true
        }
        return false
    }

}
