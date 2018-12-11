//
//  ImageLayerVC.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class ImageLayerViewControl: BaseLayerViewControl {
    @IBOutlet weak var containerView: UIView!
    
    var backSegueName : String = ""
    
    var editLayer : ImageLayer {
        get {
            return self.layer as! ImageLayer
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if let nv = segue.destination as? ImageCategoryViewControl {
            nv.backSegueName = "unwindToImageLayer"
        }
        if let nv = segue.destination as? ColorSelectViewControl {
            nv.editColor = self.editLayer.fillColor.Color
            nv.backSegueName = "unwindToImageLayer"
        }
    }
    
    private var imageSize : CGSize = CGSize.init(width: 100, height: 100)
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.setImageCell(imageName: self.editLayer.imageName, indexPath: indexPath, size: imageSize)
                break
            case 1:
                self.setCheckmarkCell(indexPath: indexPath, checked: editLayer.fillWithColor)
                break
            case 2:
                self.setColorCell(color: editLayer.fillColor.Color, indexPath: indexPath)
                break
            default:
                break
            }
        }
    }
    
    
    
    @IBAction func unwindToImageLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            editLayer.imageName = nv.imageName
            let image = UIImage.init(named: nv.imageName)
            self.setImageCell(image: image!, indexPath: IndexPath.init(row: 0, section: 0), size: imageSize)
            self.watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? ImageCategoryViewControl {
            if nv.photoImage != nil {
                self.setImageCell(image: nv.photoImage!, indexPath: IndexPath.init(row: 0, section: 0), size: imageSize)
                editLayer.imageData = nv.photoImage!.jpegData(compressionQuality: 0.4)
                self.watch?.refreshWatch()
            }
        }
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            self.editLayer.fillColor.Color = nv.editColor!
            self.setColorCell(color: editLayer.fillColor.Color, indexPath: IndexPath.init(row: 2, section: 0))
            self.watch?.refreshWatch()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.row == 1) {
            self.editLayer.fillWithColor = !self.editLayer.fillWithColor
            self.setCheckmarkCell(indexPath: indexPath, checked: editLayer.fillWithColor)
            self.watch?.refreshWatch()
        }
    }
    
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.backToLayerManager()
    }
    
}
