//
//  DataImageLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/9.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class DateImageLayerViewControl: BaseLayerViewControl {

//    var watch : MyWatch?
//    var layer : DateImageLayer?
//    var editRowIndex : IndexPath?

    private var editLayer: DateImageLayer {
        get {
            return self.layer as! DateImageLayer
        }
    }

    private var IMAGEBKSIZE: CGSize = CGSize.init(width: 60, height: 60)

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                self.setImageCell(imageName: editLayer.pointerImage, indexPath: indexPath, size: IMAGEBKSIZE)
            case 1:
                self.setColorCell(color: editLayer.pointerImageColor.Color, indexPath: indexPath)
            case 2:
                self.setLabelStepperCell(name: "Begin Angle", value: editLayer.beginAngle, indexPath: indexPath)
            case 3:
                self.setLabelStepperCell(name: "Start Angle", value: editLayer.startAngle, indexPath: indexPath)
            case 4:
                self.setLabelStepperCell(name: "End Angle", value: editLayer.endAngle, indexPath: indexPath)
            default:
                break
            }
        default:
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let cell = sender as? UITableViewCell {
            let index = self.tableView.indexPath(for: cell)!
            if let nv = segue.destination as? ImageSelectViewControl {
                nv.imageList = ResManager.Manager.getImages(category: ResManager.InfoDatePointer)
                nv.imageName = editLayer.pointerImage
                nv.backSegueName = "unwindToDateImageLayer"
                nv.editIndexPath = index
            } else if let nv = segue.destination as? ColorSelectViewControl {
                nv.editColor = editLayer.pointerImageColor.Color
                nv.backSegueName = "unwindToDateImageLayer"
                nv.editIndexPath = index
            }

        }
    }

    @IBAction func unwindToDateImageLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            self.editLayer.pointerImage = nv.imageName
            self.setImageCell(imageName: nv.imageName, indexPath: nv.editIndexPath!, size: IMAGEBKSIZE)
            self.watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            self.editLayer.pointerImageColor.Color = nv.editColor!
            self.setColorCell(color: nv.editColor!, indexPath: nv.editIndexPath!)
            self.watch?.refreshWatch()
        }
    }

    @IBAction func beginAngleValueChanged(_ sender: Any) {
        self.editLayer.beginAngle = CGFloat((sender as! UIStepper).value)
        self.setLabelSliderCell(name: "Begin Angle", value: self.editLayer.beginAngle, indexPath: IndexPath.init(row: 2, section: 0), setSlider: false)
        self.watch?.refreshWatch()
    }
    
    @IBAction func startAngleValueChanged(_ sender: Any) {
        self.editLayer.startAngle = CGFloat((sender as! UIStepper).value)
        self.setLabelSliderCell(name: "Start Angle", value: self.editLayer.startAngle, indexPath: IndexPath.init(row: 3, section: 0), setSlider: false)
        self.watch?.refreshWatch()
    }
    @IBAction func endAngleValueChanged(_ sender: Any) {
        self.editLayer.endAngle = CGFloat((sender as! UIStepper).value)
        self.setLabelSliderCell(name: "End Angle", value: self.editLayer.endAngle, indexPath: IndexPath.init(row: 4, section: 0), setSlider: false)
        self.watch?.refreshWatch()
    }
    

    @IBAction func DoneButtonClick(_ sender: Any) {
        self.backToLayerManager()
    }

}
