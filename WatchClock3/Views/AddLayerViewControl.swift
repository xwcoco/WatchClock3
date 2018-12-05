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
            if let cell = sender as? UITableViewCell {
                let index = self.tableView.indexPath(for: cell)!
                var layer: TextLayer?
                if (index.row == 0) {
                    layer = TextLayer()
                } else if (index.row == 1) {
                    layer = LocationLayer()
                } else {
                    layer = ImageLocationLayer()
                }
                nv.watch = self.watch
                self.watch?.addLayer(layer: layer!)
                nv.layer = layer
            }
        }

        if let nv = segue.destination as? WeatherLayerViewControl {
            let layer = WeatherLayer()
            nv.watch = self.watch
            nv.layer = layer
            self.watch?.addLayer(layer: layer)
        }

        if let nv = segue.destination as? EmptyLayerViewControl {
            if let cell = sender as? UITableViewCell {
                let index = self.tableView.indexPath(for: cell)!
                if (index.section == 4 && index.row == 0) {
                    let layer = MagicLayer()
                    self.watch?.addLayer(layer: layer)
                    nv.watch = self.watch
                    nv.layer = layer
                } else if (index.section == 4 && index.row == 1) {
                    let layer = MoonLayer()
                    self.watch?.addLayer(layer: layer)
                    nv.watch = self.watch
                    nv.layer = layer
                }

            }

        }
    }

//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if (indexPath.section == 4 && indexPath.row == 0) {
//            let layer = MagicLayer()
//            self.watch?.addLayer(layer: layer)
//            self.watch?.refreshWatch()
//            self.performSegue(withIdentifier: self.backSegueName, sender: self)
//        }
//    }

}

