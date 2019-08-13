//
//  FeedWrapper.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/13/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import Foundation

struct FeedWrapper: Codable {
    var status: String?
    var feed: FeedDescriptor?
    var items: [FeedItem]
}
