//
//  EmptyResultsViewController.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/14/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit

protocol EmptyResultsViewControllerDelegate: class {
    func emptyResultsViewControllerDidTapReload(_ viewController: EmptyResultsViewController)
}

class EmptyResultsViewController: UIViewController {
    
    weak var delegate: EmptyResultsViewControllerDelegate?
    
    override func loadView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "ToptalIcon_128")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the text label for the empty results
        let emptyResultsLabel = UILabel()
        emptyResultsLabel.textAlignment = .center
        emptyResultsLabel.numberOfLines = 0
        emptyResultsLabel.textColor = .darkGray
        emptyResultsLabel.text = NSLocalizedString("No Results", comment: "communicates that there are no feed results to show")
        emptyResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the reload button
        let reloadButton = UIButton(type: .roundedRect)
        let buttonTitle = NSLocalizedString("Reload", comment: "call to action after 0 results are returned")
        reloadButton.setTitle(buttonTitle, for: .normal)
        reloadButton.addTarget(self, action: #selector(EmptyResultsViewController.didTapRetryButton(_:)), for: .touchUpInside)
        reloadButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Assemble the stack view for the UI
        let stackView = UIStackView(arrangedSubviews: [imageView, emptyResultsLabel, reloadButton])
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
    }
    
    @objc func didTapRetryButton(_ sender: UIButton!) {
        delegate?.emptyResultsViewControllerDidTapReload(self)
    }
}
