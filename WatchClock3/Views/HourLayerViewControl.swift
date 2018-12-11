//
//  HourLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/30.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit


//enum HourLayerEditMode  {
//    case HourLayerMode
//    case MinuteLayerMode
//    case SecondLayerMode
//}

class HourLayerViewControl: BaseLayerViewControl {
    
    var editLayer : HourLayer {
        get {
            return self.layer as! HourLayer
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nv = segue.destination as? ImageSelectViewControl {
            nv.backSegueName = "unwindToHourLayer"
            if layer is SecondsLayer {
                nv.imageList = ResManager.Manager.getImages(category: ResManager.Seconds)
            } else if layer is MinuteLayer {
                nv.imageList = ResManager.Manager.getImages(category: ResManager.Minutes)
            } else {
                nv.imageList = ResManager.Manager.getImages(category: ResManager.Hours)
            }
            
            nv.imageName = self.editLayer.imageName
            nv.itemHeight = 80
            nv.itemWidth = 30
        }
    }
    
    private var imageSize : CGSize = CGSize.init(width: 30, height: 80)
    
    @IBAction func unwindToHourLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            self.editLayer.imageName = nv.imageName
            
            self.setImageCell(imageName: nv.imageName, indexPath: IndexPath.init(row: 0, section: 0), size: self.imageSize)
            
            let anchor = ResManager.Manager.getHandAnchorPoint(nv.imageName)
            if (anchor != 0) {
                editLayer.anchorFromBottom = anchor
                self.setLabelStepperCell(name: "Dist To Bottom", value: editLayer.anchorFromBottom, indexPath: IndexPath.init(row: 0, section: 1))
            }
            
            self.watch?.refreshWatch()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            let imageName = editLayer.imageName
            if (imageName == "") {
                self.setImageCell(imageName: "empty", indexPath: indexPath, size: self.imageSize)
            } else {
                self.setImageCell(imageName: imageName, indexPath: indexPath, size: self.imageSize)
            }
        }
        
        if (indexPath.section == 1) {
            self.setLabelStepperCell(name: "Dist To Bottom", value: editLayer.anchorFromBottom, indexPath: indexPath)
        }
    }
    
    @IBAction func xSteperValueChanged(_ sender: Any) {
        editLayer.anchorFromBottom = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Dist To Bottom", value: editLayer.anchorFromBottom, indexPath: IndexPath.init(row: 0, section: 1), setStepper: false)
        self.watch?.refreshWatch()
    }
    
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.backToLayerManager()
    }
}
