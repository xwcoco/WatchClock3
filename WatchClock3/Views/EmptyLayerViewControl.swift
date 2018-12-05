//
//  EmptyLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/5.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class EmptyLayerViewControl: UITableViewController {
    var watch : MyWatch?
    var layer : WatchLayer?
    var editRowIndex : IndexPath?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? LayerPropertyViewControl {
            nv.watch = self.watch
            nv.layer = self.layer
        }
    }
    
    private var isOK : Bool = false
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.isOK = true
        self.performSegue(withIdentifier: "unwindToLayerManager", sender: self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if parent == nil && !isOK && editRowIndex == nil {
            self.watch?.deleteLayer(layer: self.layer!)
            self.watch?.refreshWatch()
        }
    }
    
}
