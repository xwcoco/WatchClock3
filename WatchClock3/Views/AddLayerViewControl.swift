//
//  AddLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class AddLayerViewControl: UITableViewController {
    var watch : MyWatch?
    
    var backSegueName : String = ""
    
    override func viewDidLoad() {
        if (self.watch?.hourHandLayer != nil) {
            let cell = self.tableView.getCell(at: IndexPath.init(row: 1, section: 0))
            cell?.textLabel?.isEnabled = false
            cell?.isUserInteractionEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? ImageLayerViewControl {
            nv.watch = self.watch
            let aLayer = ImageLayer()
            watch?.addLayer(layer: aLayer)
            nv.layer = aLayer
            nv.backSegueName = self.backSegueName
        }
        if let nv = segue.destination as? HourLayerViewControl {
            if let cell = sender as? UITableViewCell {
                let index = self.tableView.indexPath(for: cell)!
            
                nv.watch = self.watch
                switch index.row {
                case 1:
                    let layer = HourLayer()
                    watch?.addLayer(layer: layer)
                    nv.layer = layer
                    break
                default:
                    break
                }
            }
            
        }
    }
    
}

