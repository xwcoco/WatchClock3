//
//  WeatherLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/3.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class WeatherLayerViewControl: UITableViewController {
    var watch : MyWatch?
    var layer : WeatherLayer?
    var editRowIndex : IndexPath?
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.setCheckmarkCell(indexPath: indexPath, checkIndex: layer!.weatherContent.rawValue)
            break
        case 1:
            switch indexPath.row {
            case 0:
                self.setCheckmarkCell(indexPath: indexPath, checked: layer!.showWeatherIcon)
                break
            case 1:
                self.setCheckmarkCell(indexPath: indexPath, checked: layer!.showColorAQI)
                break
            case 2:
                self.setFontCell(fontName: layer!.fontName, indexPath: indexPath)
                break
            case 3:
                self.setLabelStepperCell(name: "Font Size", value: layer!.fontSize, indexPath: indexPath)
                break
            case 4:
                self.setColorCell(color: layer!.textColor.Color, indexPath: indexPath)
                break
            case 5:
                self.setCheckmarkCell(indexPath: indexPath, checked: layer!.showTempUnit)
            default:
                break
            }
        case 2:
            if (indexPath.row == 0) {
                self.setImageCell(imageName: layer!.backImage, indexPath: indexPath, size: CGSize.init(width: 40, height: 40))
            } else {
                self.setLabelStepperCell(name: "Weather Icon Size", value: layer!.weatherIconSize, indexPath: indexPath)
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
            if let nv = segue.destination as? FontSelectViewControl {
                nv.selectedFontName = layer!.fontName
                nv.editRowIndex = index
                nv.backToSegueName = "unwindToWeatherLayer"
            }
            if let nv = segue.destination as? ColorSelectViewControl {
                nv.editColor = layer!.textColor.Color
                nv.editIndexPath = index
                nv.backSegueName = "unwindToWeatherLayer"
            }
            if let nv = segue.destination as? ImageSelectViewControl {
                nv.editIndexPath = index
                nv.imageName = layer!.backImage
                nv.imageList = ResManager.Manager.getImages(category: ResManager.Infoback)
                nv.backSegueName = "unwindToWeatherLayer"
            }
        }
    }
    
    
    @IBAction func IconSizeStepperVallueChanged(_ sender: Any) {
        self.layer!.weatherIconSize = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Weather Icon Size", value: layer!.weatherIconSize, indexPath: IndexPath.init(row: 1, section: 2), setStepper: false)
        self.watch?.refreshWatch()
    }
    
    @IBAction func fontSizeStepperValueChanged(_ sender: Any) {
        self.layer!.fontSize = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Font Size", value: layer!.fontSize, indexPath: IndexPath.init(row: 3, section: 1), setStepper: false)
        self.watch?.refreshWatch()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.setNewCheckmark(section: indexPath.section, cellNum: 9, newIndex: indexPath.row)
            self.layer!.weatherContent = WeatherContentStyle(rawValue: indexPath.row)!
            watch?.refreshWatch()
        case 1:
            switch indexPath.row {
            case 0:
                self.layer!.showWeatherIcon = !self.layer!.showWeatherIcon
                self.setCheckmarkCell(indexPath: indexPath, checked: layer!.showWeatherIcon)
                self.watch?.refreshWatch()
                break
            case 1:
                self.layer!.showColorAQI = !self.layer!.showColorAQI
                self.setCheckmarkCell(indexPath: indexPath, checked: layer!.showColorAQI)
                self.watch?.refreshWatch()
            case 5:
                self.layer?.showTempUnit = !self.layer!.showTempUnit
                self.setCheckmarkCell(indexPath: indexPath, checked: self.layer!.showTempUnit)
                self.watch?.refreshWatch()
            default:
                break
            }
            
        default:
            break
        }
    }
    
    @IBAction func unwindToWeatherLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? FontSelectViewControl {
            layer!.fontName = nv.selectedFontName
            setFontCell(fontName: layer!.fontName, indexPath: nv.editRowIndex!)
            watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            layer!.textColor.Color = nv.editColor!
            setColorCell(color: layer!.textColor.Color, indexPath: nv.editIndexPath!)
            watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            layer!.backImage = nv.imageName
            setImageCell(imageName: layer!.name, indexPath: nv.editIndexPath!, size: CGSize.init(width: 40, height: 40))
            watch?.refreshWatch()
        }
    }
    
    private var isOK : Bool = false
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.isOK = true
        self.performSegue(withIdentifier: "unwindToLayerManager", sender: self)
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if (parent == nil && !isOK && editRowIndex == nil) {
            self.watch?.deleteLayer(layer: self.layer!)
            self.watch?.refreshWatch()
        }
    }
    
    
    
}
