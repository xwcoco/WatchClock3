//
//  WatchCollectionTabViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/6.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class WatchCollectionTabViewControl: UIViewController, WatchCollectionPageActive {


    @IBOutlet weak var buttonsView: UIStackView!

    @IBOutlet weak var containerView: UIView!


    private var pageView: WatchCollectionPageViewControl?
    override func viewDidLoad() {

        self.setButtonTitle()
        self.buttonsView.layoutIfNeeded()
//        for view in self.buttonsView.subviews {
//            if let button = view as? UIButton {
//                button.titleLabel?.text =
//            }
//        }
//        self.CreateButtons()
    }

    func setButtonTitle() -> Void {
        let keys = WatchCollectionManager.Manager.getWatchKeys()
        for i in 0..<keys.count {
            if let button = self.buttonsView.subviews[i] as? UIButton {
                button.titleLabel?.text = keys[i]
            }
        }
    }

    @IBAction func CateButtonClick(_ sender: UIButton) {
        let cate = sender.titleLabel?.text
        self.pageView?.ActivePageByName(name: cate!)
        self.PageActive(cate: cate!)
    }

    @IBOutlet weak var Button1: UIButton!
    @IBOutlet weak var Button2: UIButton!

    @IBOutlet weak var Button3: UIButton!
    @IBOutlet weak var Button4: UIButton!
//    override func viewDidAppear(_ animated: Bool) {
////        self.setButtonTitle()
//    self.setButtonTitle()
//        self.Button1.titleLabel?.text = "Nike"
//    self.buttonsView.layoutIfNeeded()
//
////        self.Button2.titleLabel?.text = "123"
//    }


//    private func CreateButtons() {
//        self.buttonsView.distribution = .equalSpacing
//        self.buttonsView.translatesAutoresizingMaskIntoConstraints = true
//        let keys = WatchCollectionManager.Manager.getWatchKeys()
//        for key in keys {
//            let button = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 375, height: 30))
//            button.titleLabel?.text = key
////            button.widthAnchor.constraint(equalToConstant: 375).isActive = true
////            button.heightAnchor.constraint(equalToConstant: 30).isActive = true
//            self.buttonsView.addArrangedSubview(button)
//        }
//        self.buttonsView.setNeedsLayout()
//    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchCollectionPageViewControl {
            nv.pageActiveDelegate = self
            self.pageView = nv
        }
    }

    func PageActive(cate: String) {
        for view in self.buttonsView.subviews {
            if let button = view as? UIButton {
                button.backgroundColor = UIColor.white
                if (button.titleLabel?.text == cate) {
                    button.backgroundColor = UIColor.yellow
                }
            }
        }
    }


}

