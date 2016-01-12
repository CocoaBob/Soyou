//
//  ProductViewController.swift
//  iPrices
//
//  Created by CocoaBob on 03/01/16.
//  Copyright © 2016 iPrices. All rights reserved.
//

class ProductViewController: UIViewController {
    
    var isEdgeSwiping: Bool = false // Use edge swiping instead of custom animator if interactivePopGestureRecognizer is trigered
    
}

// MARK: UIGestureRecognizerDelegate
extension ProductViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == self.navigationController?.interactivePopGestureRecognizer {
            self.isEdgeSwiping = true
        }
        return true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
        // Make sure interactive gesture's delegate is self in case if interactive transition is cancelled
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        // Reset isEdgeSwiping to false, if interactive transition is cancelled
        self.isEdgeSwiping = false
    }
}

// MARK: ZoomInteractiveTransition
extension ProductViewController: ZoomTransitionProtocol {
    
    func viewForZoomTransition(isSource: Bool) -> UIView? {
        return self.view
    }
    
    func shouldAllowZoomTransitionForOperation(operation: UINavigationControllerOperation, fromViewController fromVC: UIViewController!, toViewController toVC: UIViewController!) -> Bool {
        // No zoom transition from ProductVC to ProductsVC
        if operation == .Push && fromVC === self && toVC is ProductsViewController {
            return false
        }
        
        // No zoom transition when edge swiping
        if self.isEdgeSwiping {
            return false
        }
        return true
    }
}