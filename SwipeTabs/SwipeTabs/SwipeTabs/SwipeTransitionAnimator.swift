//
//  SwipeTransitionAnimator.swift
//  Overlayer
//
//  Created by アンドレ on 2016/09/25.
//  Copyright © 2016年 アンドレ. All rights reserved.
//

import UIKit

@objc public class SwipeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let targetEdge: UIRectEdge

    public init(targetEdge edge: UIRectEdge) {
        targetEdge = edge
        
        if .left != edge && .right != edge {
            assert(false, "targetEdge must be one of UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        super.init()
    }
    
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let fromViewController = transitionContext.viewController(forKey: .from)
        let toViewController = transitionContext.viewController(forKey: .to)
        
        let containerView = transitionContext.containerView
        
        let fromView = transitionContext.view(forKey: .from)
        let toView = transitionContext.view(forKey: .to)

        let fromFrame = { () -> CGRect in
            if let fromController = fromViewController {
                return transitionContext.initialFrame(for: fromController)
            }
            return CGRect.zero
        }()
        
        let toFrame = { () -> CGRect in
            if let toController = toViewController {
                return transitionContext.finalFrame(for: toController)
            }
            return CGRect.zero
        }()
        
        let offset: CGVector = {
            if self.targetEdge == .left {
                return CGVector(dx: -1.0, dy: 0.0)
            }
            return CGVector(dx: 1.0, dy: 0.0)
        }()
        
        fromView?.frame = fromFrame
        
        if let targetView = toView {
            targetView.frame = toFrame.offsetBy(dx: toFrame.size.width * offset.dx * -1.0, dy: toFrame.size.height * offset.dy * -1.0)
            containerView.addSubview(targetView)
        }
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: transitionDuration, animations: {
            fromView?.frame = fromFrame.offsetBy(dx: fromFrame.size.width * offset.dx, dy: fromFrame.size.height * offset.dy)
            toView?.frame = toFrame

            }, completion: { (finished: Bool) in
                let wasCancelled = transitionContext.transitionWasCancelled
                transitionContext.completeTransition(!wasCancelled)
                UIView.animate(withDuration: 0.22, animations: {
                    toViewController?.setNeedsStatusBarAppearanceUpdate()
                })
                
        })
    }
}
