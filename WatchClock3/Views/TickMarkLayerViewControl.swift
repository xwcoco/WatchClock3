//
//  TickMarkLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/1.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class TickMarkLayerViewControl: BaseLayerViewControl {
    var editLayer: TickMarkLayer {
        get {
            return self.layer as! TickMarkLayer
        }
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.setCheckmarkCell(indexPath: indexPath, checkIndex: editLayer.tickmarkStyle.rawValue)
            break
        case 1:
            self.setCheckmarkCell(indexPath: indexPath, checkIndex: editLayer.numeralStyle.rawValue)
            break
        case 2:
            if (indexPath.row == 0) {
                self.setFontCell(fontName: editLayer.fontName, indexPath: indexPath)
            }
            if (indexPath.row == 1) {
                self.setLabelStepperCell(name: "Font Size", value: editLayer.fontSize, indexPath: indexPath, setStepper: true)
            }
            if (indexPath.row == 2) {
                self.setColorCell(color: editLayer.textColor.Color, indexPath: indexPath)
            }
            if (indexPath.row == 3) {
                setLabelStepperCell(name: "Margin", value: editLayer.labelMargin, indexPath: indexPath, setStepper: true, decimalNum: 0)
            }
            if (indexPath.row == 4) {
                if (self.layer is RectTickMarkLayer) {
                    setLabelStepperCell(name: "X Margin", value: (self.layer as! RectTickMarkLayer).labelXMargin, indexPath: indexPath, setStepper: true, decimalNum: 0)
                    
                } else {
                    cell.isHidden = true
                }
            }
            break
        case 3:
            if (indexPath.row == 0) {
                self.setColorCell(color: editLayer.alternateMajorMarkColor.Color, indexPath: indexPath)
            }
            if (indexPath.row == 1) {
                self.setColorCell(color: editLayer.alternateMinorMarkColor.Color, indexPath: indexPath)
            }
            if (indexPath.row == 2) {
                self.setColorCell(color: editLayer.alternateTextColor.Color, indexPath: indexPath)
            }
            break
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.editLayer.tickmarkStyle = TickmarkStyle(rawValue: indexPath.row)!
            self.setNewCheckmark(section: 0, cellNum: 3, newIndex: indexPath.row)
            self.watch?.refreshWatch()
            break
        case 1:
            self.editLayer.numeralStyle = NumeralStyle(rawValue: indexPath.row)!
            self.setNewCheckmark(section: 1, cellNum: 2, newIndex: indexPath.row)
            self.watch?.refreshWatch()
            break
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let cell = sender as? UITableViewCell {
            let index = self.tableView.indexPath(for: cell)!
            if let nv = segue.destination as? ColorSelectViewControl {
                nv.editIndexPath = index
                if index.section == 2 && index.row == 2 {
                    nv.editColor = editLayer.textColor.Color
                } else if index.section == 3 && index.row == 0 {
                    nv.editColor = editLayer.alternateMajorMarkColor.Color
                } else if index.section == 3 && index.row == 1 {
                    nv.editColor = editLayer.alternateMinorMarkColor.Color
                } else if index.section == 3 && index.row == 2 {
                    nv.editColor = editLayer.alternateTextColor.Color
                }
                nv.backSegueName = "unwindToTickMarkLayer"
            }
            if let nv = segue.destination as? FontSelectViewControl {
                nv.editRowIndex = index
                nv.selectedFontName = editLayer.fontName
                nv.backToSegueName = "unwindToTickMarkLayer"
            }
        }

    }

    @IBAction func unwindToTickMarkLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            self.setColorCell(color: nv.editColor!, indexPath: nv.editIndexPath!)
            let index = nv.editIndexPath!
            if index.section == 2 && index.row == 2 {
                editLayer.textColor.Color = nv.editColor!
            } else if index.section == 3 && index.row == 0 {
                editLayer.alternateMajorMarkColor.Color = nv.editColor!
            } else if index.section == 3 && index.row == 1 {
                editLayer.alternateMinorMarkColor.Color = nv.editColor!
            } else if index.section == 3 && index.row == 2 {
                editLayer.alternateTextColor.Color = nv.editColor!
            }
            self.watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? FontSelectViewControl {
            self.setFontCell(fontName: nv.selectedFontName, indexPath: nv.editRowIndex!)
            editLayer.fontName = nv.selectedFontName
            self.watch?.refreshWatch()
        }
    }
    
    @IBAction func fontSizeStepperValueChanged(_ sender: Any) {
        self.editLayer.fontSize = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Font Size", value: editLayer.fontSize, indexPath: IndexPath.init(row: 1, section: 2))
        self.watch?.refreshWatch()
    }
    @IBAction func marginStepperValueChanged(_ sender: Any) {
        self.editLayer.labelMargin = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Margin", value: self.editLayer.labelMargin, indexPath: IndexPath.init(row: 3, section: 2), setStepper: false, decimalNum: 0)
        self.watch?.refreshWatch()
    }
    
    
    @IBAction func XMarginStepperValueChanged(_ sender: Any) {
        if self.layer is RectTickMarkLayer {
            (self.layer as! RectTickMarkLayer).labelXMargin = CGFloat((sender as! UIStepper).value)
            self.setLabelStepperCell(name: "X Margin", value:  (self.layer as! RectTickMarkLayer).labelXMargin, indexPath: IndexPath.init(row: 4, section: 2), setStepper: false, decimalNum: 0)
        }
    }
    
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.backToLayerManager()
    }
    
}
