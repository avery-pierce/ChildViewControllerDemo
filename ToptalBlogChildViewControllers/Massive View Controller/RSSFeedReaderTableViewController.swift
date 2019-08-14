//
//  RSSFeedReaderTableViewController.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/13/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit
import SafariServices

class RSSFeedReaderTableViewController: UITableViewController {
    
    var feedItems: [FeedItem]?
    var error: FeedReaderError?
    
    var backgroundView: UIView!
    var backgroundLoadingView: UIView!
    
    var backgroundErrorView: UIView!
    var backgroundErrorLabel: UILabel!
    var backgroundErrorRetryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Toptal Blog", comment: "screen title")
        
        // Setup the table view
        loadBackgroundView()
        setupPullToRefresh()
        registerCells()
        
        // Begin loading the content
        initialLoad()
    }
    
    func initialLoad() {
        showLoadingView()
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
            feedItems = wrapper.items
            error = nil
            showResults()
        case .failure(let resultError):
            feedItems = nil
            error = resultError
            configureErrorState(resultError)
            showErrorView()
        }
        
        tableView.reloadData()
    }
    
    func configureErrorState(_ error: FeedReaderError) {
        backgroundErrorLabel.text = error.localizedDescription
        backgroundErrorRetryButton.isEnabled = true
    }
    
    func showLoadingView() {
        backgroundLoadingView.isHidden = false
        backgroundErrorView.isHidden = true
        tableView.separatorStyle = .none
    }
    
    func showErrorView() {
        backgroundLoadingView.isHidden = true
        backgroundErrorView.isHidden = false
        tableView.separatorStyle = .none
    }
    
    func showResults() {
        refreshControl?.endRefreshing()
        backgroundLoadingView.isHidden = true
        backgroundErrorView.isHidden = true
        tableView.separatorStyle = .singleLine
    }
    
    // MARK: - Setup
    
    func loadBackgroundView() {
        loadBackgroundLoadingView()
        loadBackgroundErrorView()
        
        backgroundView = UIView()
        
        // Embed the loading view
        backgroundView.addSubview(backgroundLoadingView)
        backgroundLoadingView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        backgroundLoadingView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        
        // Embed the error view
        backgroundView.addSubview(backgroundErrorView)
        backgroundErrorView.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        backgroundErrorView.centerYAnchor.constraint(equalTo: backgroundView.centerYAnchor).isActive = true
        backgroundErrorView.widthAnchor.constraint(lessThanOrEqualTo: backgroundView.widthAnchor, multiplier: 0.8).isActive = true
        
        tableView.backgroundView = backgroundView
    }
    
    func loadBackgroundLoadingView() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the label for the loading state
        let loadingLabel = UILabel()
        loadingLabel.text = NSLocalizedString("Loading...", comment: "presented with a loading spinner")
        loadingLabel.textColor = .darkGray
        loadingLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Assemble the stack view for the error UI
        let stackView = UIStackView(arrangedSubviews: [activityIndicator, loadingLabel])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundLoadingView = stackView
    }
    
    func loadBackgroundErrorView() {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the text label for the error message
        backgroundErrorLabel = UILabel()
        backgroundErrorLabel.textAlignment = .center
        backgroundErrorLabel.numberOfLines = 0
        backgroundErrorLabel.textColor = .darkGray
        backgroundErrorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the error retry button
        backgroundErrorRetryButton = UIButton(type: .roundedRect)
        let buttonTitle = NSLocalizedString("Retry", comment: "call to action after an error occurs")
        backgroundErrorRetryButton.setTitle(buttonTitle, for: .normal)
        backgroundErrorRetryButton.addTarget(self, action: #selector(RSSFeedReaderTableViewController.didTapRetryButton(_:)), for: .touchUpInside)
        backgroundErrorRetryButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Assemble the stack view for the error UI
        let stackView = UIStackView(arrangedSubviews: [imageView, backgroundErrorLabel, backgroundErrorRetryButton])
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.spacing = 8.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        backgroundErrorView = stackView
    }
    
    func registerCells() {
        let nib = UINib(nibName: "RSSFeedItemTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ReuseIdentifiers.feedItem)
    }
    
    func setupPullToRefresh() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(RSSFeedReaderTableViewController.didPullToRefresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    // MARK: - Actions
    
    @objc func didTapRetryButton(_ sender: UIButton!) {
        showLoadingView()
        loadFeed()
    }
    
    @objc func didPullToRefresh(_ sender: UIRefreshControl!) {
        // Do not display the loading view when doing a pull-to-refresh.
        // The current table view content should remain visible.
        loadFeed()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard feedItems != nil else { return 0 }
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let feedItems = feedItems else { return 0 }
        return feedItems.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let feedItem = feedItems![indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ReuseIdentifiers.feedItem, for: indexPath) as! RSSFeedItemTableViewCell
        cell.configure(with: feedItem)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let feedItem = feedItems![indexPath.row]
        guard let link = feedItem.link else { return }
        
        let viewController = SFSafariViewController(url: link)
        self.present(viewController, animated: true, completion: nil)
    }
    
    enum ReuseIdentifiers {
        static let feedItem = "FeedItem"
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
    
    func simulateResult(_ result: Result<FeedWrapper, FeedReaderError>) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.handleResult(result)
        }
    }
}
