//
//  InterfaceController.swift
//  WatchClock3 WatchKit Extension
//
//  Created by 徐卫 on 2018/11/27.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import WatchKit

class InterfaceController: WKInterfaceController {

    @IBOutlet weak var scene: WKInterfaceSKScene!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        let watch = MyWatch()
        scene.presentScene(watch.scene)
        
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
