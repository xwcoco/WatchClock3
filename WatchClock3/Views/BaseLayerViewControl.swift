//
//  BaseLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/9.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class BaseLayerViewControl : UITableViewController {
    var watch : MyWatch?
    var layer : WatchLayer?
    var editRowIndex : IndexPath?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? BaseLayerViewControl {
            nv.watch = self.watch
            nv.layer = self.layer
            
            if let cell = sender as? UITableViewCell {
                let index = self.tableView.indexPath(for: cell)!
                nv.editRowIndex = index
            }
        }
    }
    
    var isOK : Bool = false
    
    func backToLayerManager() -> Void {
        self.isOK = true
        self.performSegue(withIdentifier: "unwindToLayerManager", sender: self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if (parent == nil && !isOK && editRowIndex == nil) {
            self.watch?.deleteLayer(layer: self.layer!)
            self.watch?.refreshWatch()
        }
    }
}
