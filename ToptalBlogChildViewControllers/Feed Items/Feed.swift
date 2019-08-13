//
//  Feed.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/13/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import Foundation

struct FeedDescriptor: Codable {
    var url: URL?
    var title: String?
    var link: URL?
    var author: String?
    var description: String?
    var image: String?
}
