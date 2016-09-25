//
//  SwipeTransitionController.swift
//  Overlayer Test App
//
//  Created by アンドレ on 2016/09/24.
//  Copyright © 2016年 アンドレ. All rights reserved.
//

import UIKit

@objc class SwipeTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    
    private weak var transitionContext: UIViewControllerContextTransitioning?
    private var initialTranslationInContainerView = CGPoint(x: 0, y: 0)
    private var initialLocationInContainerView = CGPoint(x: 0, y: 0)
    private let gestureRecognizer: UIPanGestureRecognizer
    
    public init(gestureRecognizer recognizer: UIPanGestureRecognizer) {
        
        self.gestureRecognizer = recognizer
        super.init()

        recognizer.addTarget(self, action: #selector(self.gestureRecognizeDidUpdate(gestureRecognizer:)))
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        
        self.initialTranslationInContainerView = self.gestureRecognizer.translation(in: transitionContext.containerView)
        self.initialLocationInContainerView = self.gestureRecognizer.location(in: transitionContext.containerView)
        
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }
    
    func percentForGesture(gesture: UIPanGestureRecognizer) -> CGFloat {
        
        let transitionContainerView : UIView? = self.transitionContext?.containerView
        let containerWidth = { () -> CGFloat in 
            if let containerView = transitionContainerView {
                return containerView.bounds.width
            }
            return CGFloat(1.0)
        }()

        let translationInContainerView = gesture.translation(in: self.transitionContext?.containerView)
        
        if (translationInContainerView.x > 0.0 && self.initialTranslationInContainerView.x < 0.0) || (translationInContainerView.x < 0.0 && self.initialTranslationInContainerView.x > 0.0) {
            return -1.0
        }
        
        return fabs(translationInContainerView.x) / containerWidth
    }
    
    @IBAction func gestureRecognizeDidUpdate(gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
       
        switch gestureRecognizer.state {
        
        case .began: break
            
        case .changed:
            
            if self.percentForGesture(gesture: gestureRecognizer) < 0.0 {
                self.cancel()
                self.gestureRecognizer.removeTarget(self, action: #selector(self.gestureRecognizeDidUpdate(gestureRecognizer:)))
            } else {
                self.update(self.percentForGesture(gesture: gestureRecognizer))
            }
            
        case .ended:
            if (self.percentForGesture(gesture: gestureRecognizer) >= 0.4) {
                self.finish()
            } else {
                self.cancel()
            }
            
        default:
            self.cancel()
            
        }
    }
}
