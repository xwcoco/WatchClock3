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
    var watch: MyWatch?

    var backSegueName: String = ""

    override func viewDidLoad() {
//        if (self.watch?.hourHandLayer != nil) {
//            let cell = self.tableView.getCell(at: IndexPath.init(row: 0, section: 1))
//            cell?.textLabel?.isEnabled = false
//            cell?.isUserInteractionEnabled = false
//        }
//        if (self.watch?.mintueHandLayer != nil) {
//            let cell = self.tableView.getCell(at: IndexPath.init(row: 1, section: 1))
//            cell?.textLabel?.isEnabled = false
//            cell?.isUserInteractionEnabled = false
//        }
//        if (self.watch?.secondsHandLayer != nil) {
//            let cell = self.tableView.getCell(at: IndexPath.init(row: 2, section: 1))
//            cell?.textLabel?.isEnabled = false
//            cell?.isUserInteractionEnabled = false
//        }
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
                case 0:
                    let layer = HourLayer()
                    watch?.addLayer(layer: layer)
                    nv.layer = layer
                    break
                case 1:
                    let layer = MinuteLayer()
                    watch?.addLayer(layer: layer)
                    nv.layer = layer
                    break
                case 2:
                    let aLayer = SecondsLayer()
                    nv.layer = aLayer
                    watch?.addLayer(layer: aLayer)
                    break
                default:
                    break
                }
            }

        }

        if let nv = segue.destination as? TickMarkLayerViewControl {
            if let cell = sender as? UITableViewCell {
                let index = self.tableView.indexPath(for: cell)!
                nv.watch = self.watch
                if index.row == 0 {
                    let layer = TickMarkLayer()
                    watch?.addLayer(layer: layer)
                    nv.layer = layer
                } else {
                    let layer = RectTickMarkLayer()
                    watch?.addLayer(layer: layer)
                    nv.layer = layer
                }

            }
        }
        if let nv = segue.destination as? TextLayerViewControl {
            let layer = TextLayer()
            nv.watch = self.watch
            self.watch?.addLayer(layer: layer)
            nv.layer = layer
        }
    }

}

