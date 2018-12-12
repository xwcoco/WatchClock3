//
//  WeatherLayerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/3.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class WeatherLayerViewControl: BaseLayerViewControl {
    var editLayer : WeatherLayer {
        get {
            return self.layer as! WeatherLayer
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.setCheckmarkCell(indexPath: indexPath, checkIndex: editLayer.weatherContent.rawValue)
            break
        case 1:
            switch indexPath.row {
            case 0:
                self.setCheckmarkCell(indexPath: indexPath, checked: editLayer.showTempUnit)
                break
            case 1:
                self.setCheckmarkCell(indexPath: indexPath, checked: editLayer.showColorAQI)
                break
            case 2:
                self.setFontCell(fontName: editLayer.fontName, indexPath: indexPath)
                break
            case 3:
                self.setLabelStepperCell(name: "Font Size", value: editLayer.fontSize, indexPath: indexPath)
                break
            case 4:
                self.setColorCell(color: editLayer.textColor.Color, indexPath: indexPath)
                break
            default:
                break
            }
        case 2:
            switch indexPath.row {
            case 0:
                self.setCheckmarkCell(indexPath: indexPath, checked: editLayer.showWeatherIcon)
            case 1:
                self.setColorCell(color: editLayer.weatherIconColor.Color , indexPath: indexPath)
            case 2:
                self.setLabelStepperCell(name: "Weather Icon Size", value: editLayer.weatherIconSize, indexPath: indexPath)
            default:
                break
            }
        case 3:
            if (indexPath.row == 0) {
                self.setImageCell(imageName: editLayer.backImage, indexPath: indexPath, size: CGSize.init(width: 40, height: 40))
            } else {
                self.setColorCell(color: editLayer.backImageColor.Color, indexPath: indexPath)
            }
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let cell = sender as? UITableViewCell {
            let index = self.tableView.indexPath(for: cell)!
            if let nv = segue.destination as? FontSelectViewControl {
                nv.selectedFontName = editLayer.fontName
                nv.editRowIndex = index
                nv.backToSegueName = "unwindToWeatherLayer"
            }
            if let nv = segue.destination as? ColorSelectViewControl {
                if index.section == 1 {
                    nv.editColor = editLayer.textColor.Color
                } else if index.section == 2 {
                    nv.editColor = editLayer.weatherIconColor.Color
                } else {
                    nv.editColor = editLayer.backImageColor.Color
                }
                nv.editIndexPath = index
                nv.backSegueName = "unwindToWeatherLayer"
            }
            if let nv = segue.destination as? ImageSelectViewControl {
                nv.editIndexPath = index
                nv.imageName = editLayer.backImage
                nv.imageList = ResManager.Manager.getImages(category: ResManager.Infoback)
                nv.backSegueName = "unwindToWeatherLayer"
            }
        }
    }
    
    
    @IBAction func IconSizeStepperVallueChanged(_ sender: Any) {
        self.editLayer.weatherIconSize = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Weather Icon Size", value: editLayer.weatherIconSize, indexPath: IndexPath.init(row: 2, section: 2), setStepper: false)
        self.watch?.refreshWatch()
    }
    
    @IBAction func fontSizeStepperValueChanged(_ sender: Any) {
        self.editLayer.fontSize = CGFloat((sender as! UIStepper).value)
        self.setLabelStepperCell(name: "Font Size", value: editLayer.fontSize, indexPath: IndexPath.init(row: 3, section: 1), setStepper: false)
        self.watch?.refreshWatch()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            self.setNewCheckmark(section: indexPath.section, cellNum: 9, newIndex: indexPath.row)
            self.editLayer.weatherContent = WeatherContentStyle(rawValue: indexPath.row)!
            watch?.refreshWatch()
        case 1:
            switch indexPath.row {
            case 0:
                self.editLayer.showTempUnit = !self.editLayer.showTempUnit
                self.setCheckmarkCell(indexPath: indexPath, checked: self.editLayer.showTempUnit)
                self.watch?.refreshWatch()
                break
            case 1:
                self.editLayer.showColorAQI = !self.editLayer.showColorAQI
                self.setCheckmarkCell(indexPath: indexPath, checked: editLayer.showColorAQI)
                self.watch?.refreshWatch()
            default:
                break
            }
        case 2:
            if (indexPath.row == 0) {
                self.editLayer.showWeatherIcon = !self.editLayer.showWeatherIcon
                self.setCheckmarkCell(indexPath: indexPath, checked: editLayer.showWeatherIcon)
                self.watch?.refreshWatch()
            }
            break
            
        default:
            break
        }
    }
    
    @IBAction func unwindToWeatherLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? FontSelectViewControl {
            editLayer.fontName = nv.selectedFontName
            setFontCell(fontName: editLayer.fontName, indexPath: nv.editRowIndex!)
            watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            if nv.editIndexPath!.section == 1 {
                editLayer.textColor.Color = nv.editColor!
            } else if nv.editIndexPath?.section == 2 {
                editLayer.weatherIconColor.Color = nv.editColor!
            } else {
                editLayer.backImageColor.Color = nv.editColor!
            }
            setColorCell(color: editLayer.textColor.Color, indexPath: nv.editIndexPath!)
            watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            editLayer.backImage = nv.imageName
            setImageCell(imageName: layer!.name, indexPath: nv.editIndexPath!, size: CGSize.init(width: 40, height: 40))
            watch?.refreshWatch()
        }
    }
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.backToLayerManager()
    }
}
