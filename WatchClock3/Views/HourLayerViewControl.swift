//
//  HourLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/30.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit


enum HourLayerEditMode  {
    case HourLayerMode
    case MinuteLayerMode
    case SecondLayerMode
}

class HourLayerViewControl: UITableViewController {
    var watch : MyWatch?
    var layer : WatchLayer?
    
    var mode : HourLayerEditMode = .HourLayerMode
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? LayerPropertyViewControl {
            nv.layer = self.layer
            nv.watch = self.watch
        }
        if let nv = segue.destination as? ImageSelectViewControl {
            nv.backSegueName = "unwindToHourLayer"
            switch mode {
            case .HourLayerMode:
                nv.imageList = ResManager.Manager.getImages(category: ResManager.Hours)
                break
            case .MinuteLayerMode:
                nv.imageList = ResManager.Manager.getImages(category: ResManager.Minutes)
                break
                
            case .SecondLayerMode:
                nv.imageList = ResManager.Manager.getImages(category: ResManager.Seconds)
                break
                
            }
            nv.imageName = (self.layer as! HourLayer).imageName
            nv.itemHeight = 80
            nv.itemWidth = 30
        }
    }
    
    private var imageSize : CGSize = CGSize.init(width: 30, height: 80)
    
    @IBAction func unwindToHourLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            (self.layer as! HourLayer).imageName = nv.imageName
            
            self.setImageCell(imageName: nv.imageName, indexPath: IndexPath.init(row: 0, section: 0), size: self.imageSize)
            
            self.watch?.refreshWatch()
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let hourLayer = self.layer as! HourLayer
        
        if (indexPath.section == 0 && indexPath.row == 0) {
            let imageName = hourLayer.imageName
            if (imageName == "") {
                self.setImageCell(imageName: "empty", indexPath: indexPath, size: self.imageSize)
            } else {
                self.setImageCell(imageName: imageName, indexPath: indexPath, size: self.imageSize)
            }
        }
        
        if (indexPath.section == 1) {
            self.setLabelStepperCell(name: "Dist To Bottom", value: hourLayer.anchorFromBottom, indexPath: indexPath)
        }
    }
    
    @IBAction func xSteperValueChanged(_ sender: Any) {
        let hourLayer = self.layer as! HourLayer
        hourLayer.anchorFromBottom = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Dist To Bottom", value: hourLayer.anchorFromBottom, indexPath: IndexPath.init(row: 0, section: 1), setStepper: false)
        self.watch?.refreshWatch()
    }
    
    
    private var isOk = false
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.isOk = true
        self.performSegue(withIdentifier: "unwindToLayerManager", sender: self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if (parent == nil && !isOk) {
            self.watch?.deleteLayer(layer: self.layer!)
            self.watch?.refreshWatch()
        }
    }
    
}
