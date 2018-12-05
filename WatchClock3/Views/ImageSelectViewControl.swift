//
//  ImageSelectViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class ImageSelectViewControl: UITableViewController {
    var imageList: [String]?
    var imageIndex: Int = 0
    var imageName : String = ""
    var itemHeight: CGFloat = 44
    var itemWidth: CGFloat = 44
    var selectTitle: String = ""
    var backSegueName: String = ""
    var editIndexPath: IndexPath?
    
    override func viewDidLoad() {
        self.navigationItem.title = selectTitle
        
        if let tmpindex = imageList?.firstIndex(of: self.imageName) {
            imageIndex = tmpindex
            var index = IndexPath.init(row: imageIndex, section: 0)
            if (imageIndex >= self.imageList!.count) {
                index = IndexPath.init(row: 0,section : 0)
            }
            self.tableView.scrollToRow(at: index, at: .middle, animated: true)
        } else {
            imageIndex = -1
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.itemHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "imageSelectCell") {
            let img = UIImage.init(named: imageList![indexPath.row])
            
            let imgSize = CGSize.init(width: self.itemWidth, height: self.itemHeight)
            
            UIGraphicsBeginImageContext(imgSize)
            
            if (img != nil) {
                if (img!.size.width > imgSize.width || img!.size.height > imgSize.height) {
                    img?.draw(in: CGRect.init(x: 0, y: 0, width: imgSize.width, height: imgSize.height))
                } else {
                    img?.draw(at: CGPoint(x: (imgSize.width - img!.size.width) / 2, y: (imgSize.height - img!.size.height) / 2))
                }
            }
            
            
            
            cell.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
            
            var tmpStr: String = imageList![indexPath.row]
            
            tmpStr = NSLocalizedString(tmpStr, comment: "")
            
            tmpStr = tmpStr.replacingOccurrences(of: "_", with: " ")
            
            cell.textLabel?.text = tmpStr
            cell.textLabel?.textColor = UIColor.white
            
            cell.selectionStyle = .none
            
            cell.accessoryType = .none
            if (indexPath.row == self.imageIndex) {
                cell.accessoryType = UITableViewCell.AccessoryType.checkmark
            }
            
            
            return cell
        }
        
        return UITableViewCell.init(style: .default, reuseIdentifier: "")
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.imageIndex = indexPath.row
        self.imageName = self.imageList![self.imageIndex]
        self.performSegue(withIdentifier: self.backSegueName, sender: self)
    }
}


extension UITableViewController {
    func setImageCell(imageName: String, indexPath: IndexPath, size: CGSize) -> Void {
        
        let cell = self.tableView.getCell(at: indexPath)
        
        var tmpImageName = imageName
        if (imageName == "") {
            tmpImageName = "empty"
        }
        
        let img = UIImage.init(named: tmpImageName)
        
        UIGraphicsBeginImageContext(size)
        
        if (img != nil) {
            if (img!.size.width > size.width || img!.size.height > size.height) {
                img?.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
            } else {
                img?.draw(at: CGPoint(x: (size.width - img!.size.width) / 2, y: (size.height - img!.size.height) / 2))
            }
        }
        
        cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    func setImageCell(image: UIImage, indexPath: IndexPath, size: CGSize = CGSize.init(width: 60, height: 60)) -> Void {
        let cell = self.tableView.getCell(at: indexPath)
        UIGraphicsBeginImageContext(size)
        
        if (image.size.width > size.width || image.size.height > size.height) {
            image.draw(in: CGRect.init(x: 0, y: 0, width: size.width, height: size.height))
        } else {
            image.draw(at: CGPoint(x: (size.width - image.size.width) / 2, y: (size.height - image.size.height) / 2))
        }
        cell?.imageView?.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        //        cell?.imageView?.image = image
    }
    
    func setColorCell(color: UIColor, indexPath: IndexPath, size: CGSize = CGSize.init(width: 40, height: 40)) {
        let cell = self.tableView.getCell(at: indexPath)
        cell?.imageView?.image = UIImage.imageWithColor(color: color, size: size)
    }
    
    func setLabelSliderCell(name: String, value: CGFloat, indexPath: IndexPath, setSlider: Bool = true,decimalNum : Int = 0) -> Void {
        let cell = self.tableView.getCell(at: indexPath)
        for i in 0..<cell!.contentView.subviews.count {
            if let label = cell?.contentView.subviews[i] as? UILabel {
                label.text = NSLocalizedString(name, comment: "") + String.init(format: " : %."+String(decimalNum)+"f", arguments: [value])
            }
            if (setSlider) {
                if let slider = cell?.contentView.subviews[i] as? UISlider {
                    slider.value = Float(value)
                }
            }
        }
    }
    
    func setLabelStepperCell(name : String, value : CGFloat, indexPath : IndexPath,setStepper : Bool = true,decimalNum : Int = 0) -> Void {
        let cell = self.tableView.getCell(at: indexPath)
        for i in 0..<cell!.contentView.subviews.count {
            if let label = cell?.contentView.subviews[i] as? UILabel {
                label.text = NSLocalizedString(name, comment: "") + String.init(format: " : %."+String(decimalNum)+"f", arguments: [value])
            }
            if (setStepper) {
                if let slider = cell?.contentView.subviews[i] as? UIStepper {
                    slider.value = Double(value)
                }
            }
        }
    }
    
    func setFontCell(fontName: String, indexPath: IndexPath) -> Void {
        let cell = self.tableView.getCell(at: indexPath)
        if (fontName != "") {
            cell?.detailTextLabel?.text = fontName
        } else {
            cell?.detailTextLabel?.text = NSLocalizedString("(none)", comment: "")
        }
        
    }
    
    func setNewCheckmark(section: Int, fromIndex: Int = 0, cellNum: Int, newIndex: Int) {
        for i in fromIndex...cellNum {
            let cell = self.tableView.getCell(at: IndexPath.init(row: i, section: section))
            cell?.accessoryType = .none
            
            if (i + fromIndex == newIndex) {
                cell?.accessoryType = .checkmark
            }
        }
        
    }
    
    func setCheckmarkCell(indexPath: IndexPath, checkIndex: Int, fromIndex: Int = 0) {
        let cell = self.tableView.getCell(at: indexPath)
        cell?.accessoryType = .none
        if (indexPath.row == checkIndex + fromIndex) {
            cell?.accessoryType = .checkmark
        }
    }
    
    func setCheckmarkCell(indexPath : IndexPath, checked : Bool) -> Void {
        let cell = self.tableView.getCell(at: indexPath)
        cell?.accessoryType = .none
        if (checked) {
            cell?.accessoryType = .checkmark
        }
    }

}
