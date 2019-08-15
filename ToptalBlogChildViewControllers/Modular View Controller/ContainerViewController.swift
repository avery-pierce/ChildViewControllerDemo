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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        addContentViewControllerToHierarchy()
    }
    
    open func setContent(_ viewController: UIViewController?) {
        guard contentViewController != viewController else { return }
        
        removeCurrentViewControllerIfNeeded()
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
        
        viewController.willMove(toParent: self)
        addChild(viewController)
        view.addSubview(viewController.view)
        activateLayoutConstraintsForContentViewController()
        viewController.didMove(toParent: self)
    }
    
    private func activateLayoutConstraintsForContentViewController() {
        guard let contentView = contentViewController?.viewIfLoaded else { return }
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        contentView.setNeedsLayout()
    }
}
