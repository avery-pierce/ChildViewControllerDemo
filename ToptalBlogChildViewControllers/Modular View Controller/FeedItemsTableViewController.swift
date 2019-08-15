//
//  FeedItemsTableViewController.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/14/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit

protocol FeedItemsTableViewControllerDelegate: class {
    func feedItemsTableViewControllerDidPullToRefresh(_ viewController: FeedItemsTableViewController)
    func feedItemsTableViewController(_ viewController: FeedItemsTableViewController, didSelect feedItem: FeedItem)
}

class FeedItemsTableViewController: UITableViewController {
    
    weak var delegate: FeedItemsTableViewControllerDelegate?
    var feedItems: [FeedItem] = [] { didSet { reloadDataIfLoaded() } }

    override func viewDidLoad() {
        super.viewDidLoad()

        registerCells()
        setupRefreshControl()
    }

    func registerCells() {
        let nib = UINib(nibName: "RSSFeedItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ReuseIdentifiers.feedItem)
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedItemsTableViewController.didPullToRefresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    func reloadDataIfLoaded() {
        guard isViewLoaded else { return }
        tableView.reloadData()
    }
    
    @objc func didPullToRefresh(_ sender: UIRefreshControl!) {
        delegate?.feedItemsTableViewControllerDidPullToRefresh(self)
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
        delegate?.feedItemsTableViewController(self, didSelect: feedItem)
    }
    
    enum ReuseIdentifiers {
        static let feedItem = "FeedItem"
    }
}
