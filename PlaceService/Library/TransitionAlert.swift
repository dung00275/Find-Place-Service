//
//  TransitionAlert.swift
//  PlaceService
//
//  Created by Dung Vu on 7/15/16.
//  Copyright © 2016 Zinio Pro. All rights reserved.
//

import Foundation
import UIKit

class AnimationAlert: NSObject, UIViewControllerAnimatedTransitioning {
    
    // Identify Status
    var isPresent: Bool = true
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let container = transitionContext.containerView()
        // Got View
        let fromView = transitionContext.view(forKey: UITransitionContextFromViewKey)
        let toView = transitionContext.view(forKey: UITransitionContextToViewKey)
        
        // Animation
        if isPresent {
            if let toView = toView {
                toView.alpha = 0
                container.addSubview(toView)
                UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: { 
                    toView.alpha = 1
                    }, completion: { _ in
                        transitionContext.completeTransition(true)
                })
                
            }else {
                transitionContext.completeTransition(true)
            }
        } else{
            if let fromView = fromView {
                UIView.animate(withDuration: 1, animations: {
                    fromView.alpha = 0
                    }, completion: { _ in
                        fromView.removeFromSuperview()
                        transitionContext.completeTransition(true)
                })
            }else {
                transitionContext.completeTransition(true)
            }
        }
        
    }
}

class AnimationAlertDelegate : NSObject, UIViewControllerTransitioningDelegate {
    
    private lazy var animation = AnimationAlert()
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animation.isPresent = false
        return animation
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animation.isPresent = true
        return animation
    }
}
