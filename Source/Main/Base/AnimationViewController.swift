//
//  AnimationViewController.swift
//  IvyGate
//
//  Created by tjvs on 2019/5/31.
//  Copyright © 2019 tjvs. All rights reserved.
//

import UIKit
import SnapKit

class AnimationViewController: UIViewController {
    
    lazy var pan: UIPanGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panAction(_:)))
    
    //MARK: 动画
    fileprivate let dismissedAnimation = DismissAnimation()
    fileprivate let presentdAnimation = PresentAnimation()
    
    fileprivate let interactiveTransitioning = UIPercentDrivenInteractiveTransition()
    
    required override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBackGesture() {
        let leftSwip = UISwipeGestureRecognizer(target: self, action: #selector(backButtonPressed))
        leftSwip.direction = .right
        self.view.addGestureRecognizer(leftSwip)
    }
    
    @objc func backButtonPressed(){
        if self.navigationController != nil {
            self.navigationController!.popViewController(animated: true)
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupBackAnimation()
    }
    
    func setupBackAnimation() {
        view.addGestureRecognizer(pan)
    }
    
    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension AnimationViewController: UIViewControllerTransitioningDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let point = pan.translation(in: view)
        return abs(point.x) > abs(point.y)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.presentdAnimation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self.dismissedAnimation
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.dismissedAnimation.isInteraction {
            return self.interactiveTransitioning
        }
        return nil
    }
    
    @objc func panAction(_ pan: UIPanGestureRecognizer) {
        guard let view = pan.view else{return}
        let point = pan.translation(in: view)
        if pan.state == UIGestureRecognizer.State.began {
            if point.x < 0 {return}
            self.dismissedAnimation.isInteraction = true
            dismiss(animated: true, completion: nil)
        }else if pan.state == UIGestureRecognizer.State.changed {
            let process = point.x/UIScreen.main.bounds.width
            self.interactiveTransitioning.update(process)
        }else {
            self.dismissedAnimation.isInteraction = false
            let loctionX = abs(Int(point.x))
            let velocityX = pan.velocity(in: pan.view).x
            if velocityX >= 800 || loctionX >= Int(UIScreen.main.bounds.width/2) {
                self.interactiveTransitioning.finish()
            }else{
                self.interactiveTransitioning.cancel()
            }
        }
    }
}

extension AnimationViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return false
    }
}
