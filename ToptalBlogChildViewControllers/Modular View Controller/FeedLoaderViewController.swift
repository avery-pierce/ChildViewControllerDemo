//
//  FeedLoaderViewController.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/14/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit
import SafariServices

class FeedLoaderViewController: ContainerViewController {
    
    lazy var feedItemsViewController: FeedItemsTableViewController = FeedItemsTableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Toptal Blog", comment: "screen title")
        
        displayLoadingScreen()
        loadFeed()
    }
    
    func loadFeed() {
        FeedReader.toptalEngineeringBlog.loadFeed { [weak self] (result) in
            self?.handleResult(result)
        }
    }
    
    func handleResult(_ result: Result<FeedWrapper, FeedReaderError>) {
        switch result {
        case .success(let wrapper):
            displayResults(wrapper)
        case .failure(let resultError):
            displayErrorScreen(for: resultError)
        }
    }
    
    // MARK: - Content Management
    
    func displayLoadingScreen() {
        let viewController = LoadingViewController()
        setContent(viewController)
    }
    
    func displayErrorScreen(for error: Error) {
        let viewController = ErrorViewController()
        viewController.delegate = self
        viewController.error = error
        setContent(viewController)
    }
    
    func displayResults(_ results: FeedWrapper) {
        if results.items.count > 0 {
            feedItemsViewController.feedItems = results.items
            feedItemsViewController.refreshControl?.endRefreshing()
            feedItemsViewController.delegate = self
            setContent(feedItemsViewController)
        } else {
            let viewController = EmptyResultsViewController()
            viewController.delegate = self
            setContent(viewController)
        }
    }
    
    // MARK: - Debugging
    
    func loadFeed(withDelay delay: TimeInterval) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: { [weak self] in
            self?.loadFeed()
        })
    }
    
    func simulateError(_ error: FeedReaderError) {
        simulateResult(.failure(error))
    }
    
    func simulateEmptyResults() {
        let mockResults = FeedWrapper(status: nil, feed: nil, items: [])
        simulateResult(.success(mockResults))
    }
    
    func simulateResult(_ result: Result<FeedWrapper, FeedReaderError>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.handleResult(result)
        }
    }
}

extension FeedLoaderViewController: ErrorViewControllerDelegate {
    func errorViewControllerDidTapRetry(_ viewController: ErrorViewController) {
        displayLoadingScreen()
        loadFeed()
    }
}

extension FeedLoaderViewController: EmptyResultsViewControllerDelegate {
    func emptyResultsViewControllerDidTapReload(_ viewController: EmptyResultsViewController) {
        displayLoadingScreen()
        loadFeed()
    }
}

extension FeedLoaderViewController: FeedItemsTableViewControllerDelegate {
    func feedItemsTableViewControllerDidPullToRefresh(_ viewController: FeedItemsTableViewController) {
        loadFeed()
    }
    
    func feedItemsTableViewController(_ viewController: FeedItemsTableViewController, didSelect feedItem: FeedItem) {
        guard let link = feedItem.link else { return }
        
        let viewController = SFSafariViewController(url: link)
        self.present(viewController, animated: true, completion: nil)
    }
}
