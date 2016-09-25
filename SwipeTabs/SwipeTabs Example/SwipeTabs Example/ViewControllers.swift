//
//  FirstViewController.swift
//  SwipeTabs Example
//
//  Created by アンドレ on 2016/09/25.
//  Copyright © 2016年 アンドレ. All rights reserved.
//

import UIKit

class StatusBarCustomViewController: UIViewController {
    @IBInspectable var lightStatusBar : Bool = false
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return lightStatusBar ? .lightContent : .default
    }
}
