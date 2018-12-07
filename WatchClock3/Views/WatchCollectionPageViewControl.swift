//
//  WatchCollectionPageViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/6.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

protocol WatchCollectionPageActive {
    func PageActive(cate : String) -> Void
}

class WatchCollectionPageViewControl: UIPageViewController,UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    
    var pageActiveDelegate : WatchCollectionPageActive?
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = watchListControl.firstIndex(of: viewController) else {
            return nil
        }
        var previousIndex = viewControllerIndex - 1
        if (previousIndex < 0) {
            previousIndex = self.watchListControl.count - 1
        }
        return self.watchListControl[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = watchListControl.firstIndex(of: viewController) else {
            return nil
        }
        var previousIndex = viewControllerIndex + 1
        if (previousIndex >= self.watchListControl.count) {
            previousIndex = 0
        }
        return self.watchListControl[previousIndex]
    }
    
 
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.transitionStyle
//            = UIPageViewController.TransitionStyle.scroll
        
        let keys = WatchCollectionManager.Manager.getWatchKeys()
//        print(keys)
        for key in keys {
            if let control = self.createWatchControl() as? WatchCollectionCategroyViewControl {
                control.categroy = key
                self.watchListControl.append(control)
            }
            
        }
        self.dataSource = self
        self.delegate = self
        
        if let firstViewController = watchListControl.first {
            setViewControllers([firstViewController],
                               direction: .forward,
                               animated: true,
                               completion: nil)
            if let nv = firstViewController as? WatchCollectionCategroyViewControl {
                self.pageActiveDelegate?.PageActive(cate: nv.categroy)
            }
        }
    }
    
//    private(set) lazy var watchListControl: [UIViewController] = {
////        return [self.newColoredViewController("Green"),
////                self.newColoredViewController("Red"),
////                self.newColoredViewController("Blue")]
//    }()

    
    var watchListControl : [UIViewController] = []
    
    private func createWatchControl() -> UIViewController {
        return UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "watchcollectionscene")
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let nv = self.viewControllers?.first as? WatchCollectionCategroyViewControl {
            self.pageActiveDelegate?.PageActive(cate: nv.categroy)
        }
    }
    
    func ActivePageByName(name : String) -> Void {
        for vc in self.watchListControl {
            if let nv = vc as? WatchCollectionCategroyViewControl {
                if nv.categroy == name {
                    self.setViewControllers([nv], direction: .forward, animated: true, completion: nil)
                    return
                }
            }
        }
    }
    
    
    
}
