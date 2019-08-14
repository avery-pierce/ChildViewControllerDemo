//
//  ErrorViewController.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/14/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit

protocol ErrorViewControllerDelegate: class {
    func errorViewControllerDidTapRetry(_ viewController: ErrorViewController)
}

class ErrorViewController: UIViewController {
    
    var error: Error? { didSet { configureIfLoaded() } }
    
    weak var errorMessageLabel: UILabel!
    weak var retryButton: UIButton!
    
    weak var delegate: ErrorViewControllerDelegate?
    
    override func loadView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "WarningSign_256")
        imageView.tintColor = .lightGray
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        // Configure the text label for the error message
        let errorMessageLabel = UILabel()
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.textColor = .darkGray
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        self.errorMessageLabel = errorMessageLabel
        
        // Configure the error retry button
        let retryButton = UIButton(type: .roundedRect)
        let buttonTitle = NSLocalizedString("Retry", comment: "call to action after an error occurs")
        retryButton.setTitle(buttonTitle, for: .normal)
        retryButton.addTarget(self, action: #selector(ErrorViewController.didTapRetryButton(_:)), for: .touchUpInside)
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        self.retryButton = retryButton
        
        // Assemble the stack view for the error UI
        let stackView = UIStackView(arrangedSubviews: [imageView, errorMessageLabel, retryButton])
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
    
    override func viewDidLoad() {
        configure()
    }
    
    @objc func didTapRetryButton(_ sender: UIButton!) {
        delegate?.errorViewControllerDidTapRetry(self)
    }
    
    func configureIfLoaded() {
        if isViewLoaded {
            configure()
        }
    }
    
    func configure() {
        errorMessageLabel?.text = error?.localizedDescription
    }
}
