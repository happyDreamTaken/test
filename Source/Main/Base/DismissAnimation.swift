//
//  DismissAnimation.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit

class DismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    
    var isInteraction = false
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        
        let containerView = transitionContext.containerView
        containerView.insertSubview(toViewController.view, at: 0)
        
        UIView.setAnimationCurve(.easeOut)
        UIView.animate(withDuration: self.transitionDuration(using: transitionContext), animations: {
            toViewController.view.transform = CGAffineTransform.identity
            fromViewController.view.transform = fromViewController.view.transform.translatedBy(x: fromViewController.view.bounds.width, y: 0)
            toViewController.view.frame = transitionContext.finalFrame(for: toViewController)
        }, completion: { (_) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        })
    }
}
