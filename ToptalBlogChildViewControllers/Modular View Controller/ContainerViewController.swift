//
//  ContainerViewController.swift
//  ToptalBlogChildViewControllers
//
//  Created by Avery Pierce on 8/14/19.
//  Copyright © 2019 Avery Pierce. All rights reserved.
//

import UIKit

open class ContainerViewController: UIViewController {
    
    private(set) public var contentViewController: UIViewController?
    
    private var activeLayoutConstraints: [NSLayoutConstraint] = []
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        addContentViewControllerToHierarchy()
    }
    
    open func setContent(_ viewController: UIViewController?) {
        guard contentViewController != viewController else { return }
        removeCurrentViewControllerIfNeeded()
        viewController?.willMove(toParent: self)
        contentViewController = viewController
        addContentviewControllerToHierarchyIfLoaded()
        viewIfLoaded?.layoutIfNeeded()
    }
    
    private func removeCurrentViewControllerIfNeeded() {
        contentViewController?.willMove(toParent: nil)
        contentViewController?.viewIfLoaded?.removeFromSuperview()
        contentViewController?.removeFromParent()
    }
    
    private func addContentviewControllerToHierarchyIfLoaded() {
        if isViewLoaded {
            addContentViewControllerToHierarchy()
        }
    }
    
    private func addContentViewControllerToHierarchy() {
        guard let viewController = contentViewController else { return }
        
        addChild(viewController)
        view.addSubview(viewController.view)
        activateLayoutConstraintsForContentViewController()
        preferredContentSize = viewController.preferredContentSize
        viewController.didMove(toParent: self)
    }
    
    private func activateLayoutConstraintsForContentViewController() {
        guard let contentView = contentViewController?.viewIfLoaded else { return }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        configureLayoutConstraints()
    }
    
    private func configureLayoutConstraints() {
        guard let contentView = contentViewController?.viewIfLoaded else { return }
        
        deactivateAllOwnedConstraints()
        activate(contentView.topAnchor.constraint(equalTo: view.topAnchor))
        activate(contentView.leftAnchor.constraint(equalTo: view.leftAnchor))
        activate(contentView.rightAnchor.constraint(equalTo: view.rightAnchor))
        activate(contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor))
        contentView.setNeedsLayout()
    }
    
    private func activate(_ constraint: NSLayoutConstraint) {
        constraint.isActive = true
        activeLayoutConstraints.append(constraint)
    }
    
    private func deactivateAllOwnedConstraints() {
        while let constraint = activeLayoutConstraints.popLast() {
            constraint.isActive = false
        }
    }
}
