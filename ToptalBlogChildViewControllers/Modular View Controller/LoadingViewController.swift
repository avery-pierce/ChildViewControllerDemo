//
//  LoadingViewController.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/14/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {
    
    weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func loadView() {
        let activityIndicator = UIActivityIndicatorView(style: .gray)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicatorView = activityIndicator
        
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
        
        view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stackView)
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 0.8).isActive = true
        view.setNeedsLayout()
    }
}
