//
//  ExploreViewModel.swift
//  Codename Starlight
//
//  Created by Marquis Kurt on 7/14/20.
//

import Foundation

public class ExploreViewModel: ObservableObject {

    @Published var tags = [Tag]()

    public func getTags() {
        AppClient.shared().getFeaturedHashtags { trends in
            self.tags = trends
        }
    }

}
