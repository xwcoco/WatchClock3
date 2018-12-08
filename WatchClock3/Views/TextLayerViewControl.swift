//
//  TextLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/2.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class TextLayerViewControl : UITableViewController {
    var watch : MyWatch?
    var layer : TextLayer?
    var editRowIndex : IndexPath?
    
    
    private var backImageSize : CGSize = CGSize.init(width: 60, height: 60)
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.setCheckmarkCell(indexPath: indexPath, checkIndex: layer!.textContent.rawValue)
            break
        case 1:
            switch indexPath.row {
            case 0:
                self.setFontCell(fontName: layer!.fontName, indexPath: indexPath)
                break
            case 1:
                self.setLabelStepperCell(name: "Font Size", value: layer!.fontSize, indexPath: indexPath)
                break
            case 2:
                self.setColorCell(color: layer!.textColor.Color, indexPath: indexPath)
                break
            case 3:
                self.setLabelStepperCell(name: "Text Top Adjust", value: layer!.textTopY, indexPath: indexPath)
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                self.setImageCell(imageName: self.layer!.backImage, indexPath: indexPath, size: backImageSize)
                break
            case 1:
                self.setColorCell(color: layer!.backImageColor.Color, indexPath: indexPath)
                break
            case 2:
                self.setLabelStepperCell(name: "Space For X", value: layer!.backImage_X, indexPath: indexPath)
            case 3:
                self.setLabelStepperCell(name: "Space For Y", value: layer!.backImage_Y, indexPath: indexPath)
            default:
                break
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? LayerPropertyViewControl {
            nv.watch = self.watch
            nv.layer = self.layer
        }
        if let cell = sender as? UITableViewCell {
            let index = self.tableView.indexPath(for: cell)!
            if let nv = segue.destination as? ColorSelectViewControl {
                if index.section == 1 {
                    nv.editColor = self.layer!.textColor.Color
                } else {
                    nv.editColor = self.layer!.backImageColor.Color
                }
                nv.editIndexPath = index
                nv.backSegueName = "unwindToTextLayer"
            }
            if let nv = segue.destination as? FontSelectViewControl {
                nv.editRowIndex = index
                nv.selectedFontName = layer!.fontName
                nv.backToSegueName = "unwindToTextLayer"
            }
            if let nv = segue.destination as? ImageSelectViewControl {
                nv.editIndexPath = index
                nv.backSegueName = "unwindToTextLayer"
                nv.imageName = layer!.backImage
                if self.layer is ImageLocationLayer {
                    nv.imageList = ResManager.Manager.getImages(category: ResManager.altitudeBG)
                } else {
                    nv.imageList = ResManager.Manager.getImages(category: ResManager.Infoback)
                }
            }
        }
    }
    
    @IBAction func unwindToTextLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            if (nv.editIndexPath!.section == 1) {
                self.layer!.textColor.Color = nv.editColor!
                self.setColorCell(color: self.layer!.textColor.Color, indexPath: nv.editIndexPath!)
            } else {
                self.layer!.backImageColor.Color = nv.editColor!
                self.setColorCell(color: self.layer!.backImageColor.Color, indexPath: nv.editIndexPath!)
            }
            self.watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? FontSelectViewControl {
            self.layer!.fontName = nv.selectedFontName
            self.setFontCell(fontName: layer!.fontName, indexPath: nv.editRowIndex!)
            self.watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            self.layer!.backImage = nv.imageName
            self.setImageCell(imageName: nv.imageName, indexPath: nv.editIndexPath!, size: backImageSize)
            self.watch?.refreshWatch()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            self.layer!.textContent = TextContentStyle(rawValue: indexPath.row)!
            self.setNewCheckmark(section: 0, cellNum: 8, newIndex: indexPath.row)
            self.watch?.refreshWatch()
        } 
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            if self.layer is LocationLayer {
                return 0
            }
            return 44
        case 1:
            return 44
        case 2:
            if indexPath.row == 0 {
                return 80
            }
            return 44
        case 3:
            return 400
        default:
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if (section == 0 && self.layer is LocationLayer) {
            return 0
        }
        return 28
    }
    
    
    @IBAction func textTopYValueChanged(_ sender: Any) {
        self.layer!.textTopY = CGFloat((sender as! UIStepper).value)
        self.setLabelSliderCell(name: "Text Top Adjuest", value: layer!.textTopY, indexPath: IndexPath.init(row: 3, section: 1), setSlider: false)
        self.watch?.refreshWatch()
    }
    
    @IBAction func spaceXValueChanged(_ sender: Any) {
        self.layer!.backImage_X = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Space For X", value: layer!.backImage_X, indexPath: IndexPath.init(row: 2, section: 2), setStepper: false, decimalNum: 0)
        self.watch?.refreshWatch()
    }
    @IBAction func spaceYValueChanged(_ sender: Any) {
        self.layer!.backImage_Y = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Space For Y", value: layer!.backImage_Y, indexPath: IndexPath.init(row: 3, section: 2), setStepper: false, decimalNum: 0)
        self.watch?.refreshWatch()
    }
    
    @IBAction func fontSizeStepperValueChanged(_ sender: Any) {
        self.layer!.fontSize = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Font Size", value: layer!.fontSize, indexPath: IndexPath.init(row: 1, section: 1), setStepper: false)
        self.watch?.refreshWatch()
    }
    
    private var isOK = false
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.isOK = true
        self.performSegue(withIdentifier: "unwindToLayerManager", sender: self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if parent == nil && !isOK && editRowIndex == nil {
            self.watch?.deleteLayer(layer: self.layer!)
            self.watch?.refreshWatch()
        }
    }
    
}

