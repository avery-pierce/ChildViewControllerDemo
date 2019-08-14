//
//  FeedLoaderViewController.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/14/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit

class FeedLoaderViewController: ContainerViewController {
    
    var refreshControl: UIRefreshControl!
    
    lazy var feedItemsViewController: FeedItemsTableViewController = {
        var viewController = FeedItemsTableViewController()
        viewController.refreshControl = refreshControl
        return viewController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Toptal Blog", comment: "screen title")
        
        setupRefreshControl()
        displayLoadingScreen()
        loadFeed()
    }
    
    func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(FeedLoaderViewController.didPullToRefresh(_:)), for: .valueChanged)
    }
    
    func loadFeed() {
        FeedReader.toptalEngineeringBlog.loadFeed { [weak self] (result) in
            self?.handleResult(result)
        }
    }
    
    func handleResult(_ result: Result<FeedWrapper, FeedReaderError>) {
        refreshControl.endRefreshing()
        
        switch result {
        case .success(let wrapper):
            displayResults(wrapper)
        case .failure(let resultError):
            displayErrorScreen(for: resultError)
        }
    }
    
    // MARK: - User Input
    
    @objc func didPullToRefresh(_ sender: UIRefreshControl!) {
        // Do not display the loading view when doing a pull-to-refresh.
        // The current table view content should remain visible.
        loadFeed()
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
