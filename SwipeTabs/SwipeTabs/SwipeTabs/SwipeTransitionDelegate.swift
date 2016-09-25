//
//  SlideTransitionDelegate.swift
//  Overlayer Test App
//
//  Created by アンドレ on 2016/09/25.
//  Copyright © 2016年 アンドレ. All rights reserved.
//

import UIKit

let MoreNavigationControllerIndex = NSNotFound

@objc public class SwipeTransitionDelegate: NSObject, UITabBarControllerDelegate {
    
    private lazy var panGestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(self.panGestureRecognizerDidPan(sender:)))
    }()
    
    @IBOutlet public var tabBarController: UITabBarController? {
        
        willSet {
            if let currentTabBarController = self.tabBarController, let tabBarDelegate = currentTabBarController.delegate, tabBarDelegate === self {
                currentTabBarController.delegate = nil
                currentTabBarController.view.removeGestureRecognizer(self.panGestureRecognizer)
            }
        }
        
        didSet {
            if let currentTabBarController = self.tabBarController, oldValue !== currentTabBarController {
                currentTabBarController.delegate = self
                currentTabBarController.view.addGestureRecognizer(self.panGestureRecognizer)
            }
        }
    }
    
    @IBAction func panGestureRecognizerDidPan(sender: UIPanGestureRecognizer) {
        
        guard nil == self.tabBarController?.transitionCoordinator else {
            return
        }
        
        if .began == sender.state || .changed == sender.state {
            self.beginInteractiveTransitionIfPossible(sender: sender)
        }
    }
    
    func beginInteractiveTransitionIfPossible(sender: UIPanGestureRecognizer) {
        
        guard let currentTabBarController = self.tabBarController else {
            return
        }
        
        guard let allViewControllers = currentTabBarController.viewControllers else {
            return
        }
        
        guard let countOfVisibleTabs = currentTabBarController.tabBar.items?.count else {
            return
        }
        
        let translation = sender.translation(in: currentTabBarController.view)
        let selectedIndex = currentTabBarController.selectedIndex
        let countOfAllControllers = allViewControllers.count
        
        UIView.animate(withDuration: 0.22,animations:{

            if translation.x > 0.0 {
                
                let previousIndex = selectedIndex - 1
                
                if selectedIndex > 0 && selectedIndex != MoreNavigationControllerIndex && selectedIndex < countOfVisibleTabs - 1 {
                    currentTabBarController.selectedIndex = previousIndex
                } else if selectedIndex > countOfVisibleTabs - 2 {
                    currentTabBarController.selectedIndex = countOfVisibleTabs - 2
                }
                
            } else if translation.x < 0.0 {
                
                let moreViewController = currentTabBarController.moreNavigationController
                let nextIndex = (selectedIndex == MoreNavigationControllerIndex ? MoreNavigationControllerIndex : selectedIndex + 1)
                
                if nextIndex < countOfVisibleTabs - 1 {
                    currentTabBarController.selectedIndex = nextIndex
                } else if nextIndex == countOfVisibleTabs - 1 {
                    if countOfAllControllers == countOfVisibleTabs {
                        currentTabBarController.selectedIndex = nextIndex
                    } else {
                        currentTabBarController.selectedViewController = moreViewController
                    }
                }
                
            } else {
                if !translation.equalTo(CGPoint.zero) {
                    sender.isEnabled = false
                    sender.isEnabled = true
                }
            }
            
        })
        
        guard let transitionCoordinator = currentTabBarController.transitionCoordinator else {
            return
        }
        
        transitionCoordinator.animate(alongsideTransition: nil, completion: { (context: UIViewControllerTransitionCoordinatorContext) in
            if (context.isCancelled) && (.changed == sender.state) {
                self.beginInteractiveTransitionIfPossible(sender: sender)
            }
        })

    }
    
    public func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        guard let currentTabBarController = self.tabBarController, currentTabBarController == tabBarController else {
            return nil
        }

        guard let viewControllers = tabBarController.viewControllers, viewControllers.count > 0 else {
            return nil
        }
        
        let findToIndex : () -> Int? = {
            if toVC == currentTabBarController.moreNavigationController {
                return MoreNavigationControllerIndex
            }
            return viewControllers.index(of: toVC)
        }
        
        let findFromIndex : () -> Int? = {
            if fromVC == currentTabBarController.moreNavigationController {
                return MoreNavigationControllerIndex
            }
            return viewControllers.index(of: fromVC)
        }
        
        guard let toIndex = findToIndex(), let fromIndex = findFromIndex() else {
            return nil
        }
        
        if toIndex > fromIndex {
            return SwipeTransitionAnimator(targetEdge: .left)
        } else {
            return SwipeTransitionAnimator(targetEdge: .right)
        }
    }
    
    public func tabBarController(_ tabBarController: UITabBarController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
     
        guard let currentTabBarController = self.tabBarController, currentTabBarController == tabBarController else {
            return nil
        }

        if .began == self.panGestureRecognizer.state || .changed == self.panGestureRecognizer.state {
            return SwipeTransitionInteractionController(gestureRecognizer: self.panGestureRecognizer)
        } else {
            return nil
        }
    }
    
}
