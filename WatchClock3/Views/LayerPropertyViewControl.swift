//
//  LayerPropertyViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/30.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class LayerPropertyViewControl: UITableViewController {
    
    var layer : WatchLayer?
    var watch : MyWatch?
    
    @IBAction func alphaSliderValueChanged(_ sender: Any) {
        layer?.alpha = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Alpha", value: layer!.alpha , indexPath: IndexPath.init(row: 2, section: 0), setStepper: false, decimalNum: 2)
        watch?.refreshWatch()
    }
    
    @IBAction func yDistSliderValueChanged(_ sender: Any) {
        layer?.y = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Y Dist To Center", value: layer!.y , indexPath: IndexPath.init(row: 1, section: 0), setStepper: false)
        watch?.refreshWatch()
    }
    
    @IBAction func xDistSliderValueChanged(_ sender: Any) {
        layer?.x = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "X Dist To Center", value: layer!.x , indexPath: IndexPath.init(row: 0, section: 0), setStepper: false)
        watch?.refreshWatch()
    }
    
    @IBAction func xScaleStepperValueChanged(_ sender: Any) {
        layer?.xScale = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "X Scale", value: layer!.xScale, indexPath: IndexPath.init(row: 3, section: 0), setStepper: false, decimalNum: 2)
        watch?.refreshWatch()
    }
    
    @IBAction func yScaleStepperValueChanged(_ sender: Any) {
        layer?.yScale = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Y Scale", value: layer!.yScale, indexPath: IndexPath.init(row: 4, section: 0), setStepper: false, decimalNum: 2)
        watch?.refreshWatch()
    }
    
    override func viewDidLoad() {
//        self.tableView.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.black
        switch indexPath.row {
        case 0:
            self.setLabelStepperCell(name: "X Dist To Center", value: layer!.x , indexPath: indexPath, setStepper: true)
            break
        case 1:
            self.setLabelStepperCell(name: "Y Dist To Center", value: layer!.y , indexPath: indexPath, setStepper: true)
            break
        case 2:
            self.setLabelStepperCell(name: "Alpha", value: layer!.alpha , indexPath: indexPath, setStepper: true,decimalNum: 2)
            break
        case 3:
            self.setLabelStepperCell(name: "X Scale", value: layer!.xScale, indexPath: indexPath, setStepper: true, decimalNum: 2)
            break
        case 4:
            self.setLabelStepperCell(name: "Y Scale", value: layer!.yScale, indexPath: indexPath, setStepper: true, decimalNum: 2)
        default:
            break
        }
    }
}
