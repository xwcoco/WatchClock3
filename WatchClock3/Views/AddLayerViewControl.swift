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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if let cell = sender as? UITableViewCell {
            let index = self.tableView.indexPath(for: cell)!

            if let nv = segue.destination as? ImageLayerViewControl {
                nv.watch = self.watch
                let aLayer = ImageLayer()
                watch?.addLayer(layer: aLayer)
                nv.layer = aLayer
                nv.backSegueName = self.backSegueName
            } else
            if let nv = segue.destination as? HourLayerViewControl {
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

            } else

            if let nv = segue.destination as? TickMarkLayerViewControl {
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
            else if let nv = segue.destination as? TextLayerViewControl {
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

            else if let nv = segue.destination as? WeatherLayerViewControl {
                let layer = WeatherLayer()
                nv.watch = self.watch
                nv.layer = layer
                self.watch?.addLayer(layer: layer)
            }

            else if let nv = segue.destination as? EmptyLayerViewControl {
                if (index.section == 5 && index.row == 0) {
                    let layer = MagicLayer()
                    self.watch?.addLayer(layer: layer)
                    nv.watch = self.watch
                    nv.layer = layer
                } else if (index.section == 5 && index.row == 1) {
                    let layer = MoonLayer()
                    self.watch?.addLayer(layer: layer)
                    nv.watch = self.watch
                    nv.layer = layer
                }

            }

            else if let nv = segue.destination as? DateImageLayerViewControl {
                nv.watch = self.watch
                var layer : WatchLayer
                switch index.row {
                case 0:
                    layer = WeekDayImageLayer()
                case 1:
                   layer = DateImageLayer()
                case 2:
                    layer = MonthImageLayer()
                default:
                    layer = BatteryImageLayer()
                    break
                }
                nv.layer = layer
                self.watch?.addLayer(layer: layer)
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

