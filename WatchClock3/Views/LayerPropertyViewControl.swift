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
        layer?.alpha = CGFloat((sender as! UISlider).value)
        self.setLabelSliderCell(name: "Alpha", value: layer!.alpha , indexPath: IndexPath.init(row: 2, section: 0), setSlider: false)
        watch?.refreshWatch()
    }
    
    @IBAction func yDistSliderValueChanged(_ sender: Any) {
        layer?.y = CGFloat((sender as! UISlider).value)
        self.setLabelSliderCell(name: "Y Dist To Center", value: layer!.x , indexPath: IndexPath.init(row: 1, section: 0), setSlider: false)
        watch?.refreshWatch()
    }
    
    @IBAction func xDistSliderValueChanged(_ sender: Any) {
        layer?.x = CGFloat((sender as! UISlider).value)
        self.setLabelSliderCell(name: "X Dist To Center", value: layer!.x , indexPath: IndexPath.init(row: 0, section: 0), setSlider: false)
        watch?.refreshWatch()
    }
    
    override func viewDidLoad() {
//        self.tableView.backgroundColor = UIColor.clear
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.black
        switch indexPath.row {
        case 0:
            self.setLabelSliderCell(name: "X Dist To Center", value: layer!.x , indexPath: indexPath, setSlider: true)
            break
        case 1:
            self.setLabelSliderCell(name: "Y Dist To Center", value: layer!.y , indexPath: indexPath, setSlider: true)
            break
        case 2:
            self.setLabelSliderCell(name: "Alpha", value: layer!.alpha , indexPath: indexPath, setSlider: true)
            break
        default:
            break
        }
    }
}
