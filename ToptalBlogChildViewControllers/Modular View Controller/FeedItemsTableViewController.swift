//
//  FeedItemsTableViewController.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/14/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit
import SafariServices

class FeedItemsTableViewController: UITableViewController {
    
    var feedItems: [FeedItem] = [] { didSet { reloadDataIfLoaded() } }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
    }

    func registerCells() {
        let nib = UINib(nibName: "RSSFeedItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ReuseIdentifiers.feedItem)
    }
    
    func reloadDataIfLoaded() {
        guard isViewLoaded else { return }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedItem = feedItems[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.feedItem, for: indexPath) as! RSSFeedItemTableViewCell
        cell.configure(with: feedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = feedItems[indexPath.row]
        guard let link = feedItem.link else { return }
        
        let viewController = SFSafariViewController(url: link)
        self.present(viewController, animated: true, completion: nil)
    }
    
    enum ReuseIdentifiers {
        static let feedItem = "FeedItem"
    }
}
