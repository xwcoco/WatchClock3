//
//  TickMarkLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/1.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class TickMarkLayerViewControl: UITableViewController {
    var watch: MyWatch?
    var layer: TickMarkLayer?
    var editRowIndex : IndexPath?

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.setCheckmarkCell(indexPath: indexPath, checkIndex: layer!.tickmarkStyle.rawValue)
            break
        case 1:
            self.setCheckmarkCell(indexPath: indexPath, checkIndex: layer!.numeralStyle.rawValue)
            break
        case 2:
            if (indexPath.row == 0) {
                self.setFontCell(fontName: layer!.fontName, indexPath: indexPath)
            }
            if (indexPath.row == 1) {
                self.setLabelStepperCell(name: "Font Size", value: layer!.fontSize, indexPath: indexPath, setStepper: true)
            }
            if (indexPath.row == 2) {
                self.setColorCell(color: layer!.textColor.Color, indexPath: indexPath)
            }
            break
        case 3:
            if (indexPath.row == 0) {
                self.setColorCell(color: layer!.alternateMajorMarkColor.Color, indexPath: indexPath)
            }
            if (indexPath.row == 1) {
                self.setColorCell(color: layer!.alternateMinorMarkColor.Color, indexPath: indexPath)
            }
            if (indexPath.row == 2) {
                self.setColorCell(color: layer!.alternateTextColor.Color, indexPath: indexPath)
            }
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.layer!.tickmarkStyle = TickmarkStyle(rawValue: indexPath.row)!
            self.setNewCheckmark(section: 0, cellNum: 3, newIndex: indexPath.row)
            self.watch?.refreshWatch()
            break
        case 1:
            self.layer!.numeralStyle = NumeralStyle(rawValue: indexPath.row)!
            self.setNewCheckmark(section: 1, cellNum: 2, newIndex: indexPath.row)
            self.watch?.refreshWatch()
            break
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? LayerPropertyViewControl {
            nv.layer = self.layer
            nv.watch = self.watch
        }
        if let cell = sender as? UITableViewCell {
            let index = self.tableView.indexPath(for: cell)!
            if let nv = segue.destination as? ColorSelectViewControl {
                nv.editIndexPath = index
                if index.section == 2 && index.row == 2 {
                    nv.editColor = layer!.textColor.Color
                } else if index.section == 3 && index.row == 0 {
                    nv.editColor = layer!.alternateMajorMarkColor.Color
                } else if index.section == 3 && index.row == 1 {
                    nv.editColor = layer!.alternateMinorMarkColor.Color
                } else if index.section == 3 && index.row == 2 {
                    nv.editColor = layer!.alternateTextColor.Color
                }
                nv.backSegueName = "unwindToTickMarkLayer"
            }
            if let nv = segue.destination as? FontSelectViewControl {
                nv.editRowIndex = index
                nv.selectedFontName = layer!.fontName
                nv.backToSegueName = "unwindToTickMarkLayer"
            }
        }

    }

    @IBAction func unwindToTickMarkLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            self.setColorCell(color: nv.editColor!, indexPath: nv.editIndexPath!)
            let index = nv.editIndexPath!
            if index.section == 2 && index.row == 2 {
                layer!.textColor.Color = nv.editColor!
            } else if index.section == 3 && index.row == 0 {
                layer!.alternateMajorMarkColor.Color = nv.editColor!
            } else if index.section == 3 && index.row == 1 {
                layer!.alternateMinorMarkColor.Color = nv.editColor!
            } else if index.section == 3 && index.row == 2 {
                layer!.alternateTextColor.Color = nv.editColor!
            }
            self.watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? FontSelectViewControl {
            self.setFontCell(fontName: nv.selectedFontName, indexPath: nv.editRowIndex!)
            layer!.fontName = nv.selectedFontName
            self.watch?.refreshWatch()
        }
    }
    
    @IBAction func fontSizeStepperValueChanged(_ sender: Any) {
        self.layer!.fontSize = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Font Size", value: layer!.fontSize, indexPath: IndexPath.init(row: 1, section: 2))
        self.watch?.refreshWatch()
    }
}
