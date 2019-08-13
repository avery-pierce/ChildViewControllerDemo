//
//  RSSFeedReaderTableViewCell.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/13/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit

class RSSFeedItemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var articleTitleLabel: UILabel!
    @IBOutlet weak var articleBylineLabel: UILabel!
    @IBOutlet weak var articleDescriptionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(with feedItem: FeedItem) {
        articleTitleLabel.text = feedItem.title
        articleBylineLabel.text = feedItem.author
        articleDescriptionLabel.text = feedItem.description
    }
    
}
