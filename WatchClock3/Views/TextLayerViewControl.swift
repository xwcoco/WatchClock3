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
            case 3:
                self.setColorCell(color: layer!.textColor.Color, indexPath: indexPath)
                break
            default:
                break
            }
        case 2:
            self.setImageCell(imageName: self.layer!.backImage, indexPath: indexPath, size: backImageSize)
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
                nv.editColor = self.layer!.textColor.Color
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
                nv.imageList = ResManager.Manager.getImages(category: ResManager.Infoback)
            }
        }
    }
    
    @IBAction func unwindToTextLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            self.layer!.textColor.Color = nv.editColor!
            self.setColorCell(color: self.layer!.textColor.Color, indexPath: nv.editIndexPath!)
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
            self.setNewCheckmark(section: 0, cellNum: 4, newIndex: indexPath.row)
            self.watch?.refreshWatch()
        } 
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

