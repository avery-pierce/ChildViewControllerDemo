//
//  FeedItem.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/13/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import Foundation

struct FeedItem: Codable {
    var title: String?
    var pubDate: String?
    var link: URL?
    var guid: String?
    var author: String?
    var thumbnail: String?
    var description: String?
    var content: String?
    var enclosure: Enclosure?
    
    struct Enclosure: Codable {
        var link: String?
    }
}
