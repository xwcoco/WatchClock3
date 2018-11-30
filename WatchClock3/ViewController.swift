//
//  ViewController.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/27.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import UIKit
import SpriteKit

class ViewController: UIViewController {

    @IBOutlet weak var myview: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let watch = MyWatch()
        watch.scene.scaleMode = .aspectFill
        myview.presentScene(watch.scene)
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }


}

