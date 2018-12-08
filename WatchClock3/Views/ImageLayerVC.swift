//
//  ImageLayerVC.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class ImageLayerViewControl: UITableViewController {
    @IBOutlet weak var containerView: UIView!
    
    var layer : ImageLayer?
    var watch : MyWatch?
    var editRowIndex : Int = 0
    
    var backSegueName : String = ""
    
    override func viewDidLoad() {
//        if let nv = self.containerView.subviews[0] as? LayerPropertyViewControl {
//            nv.layer = watchLayer
//        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        if let nv = segue.destination as? ImageCategoryViewControl {
            nv.backSegueName = "unwindToImageLayer"
        }
        if let nv = segue.destination as? LayerPropertyViewControl {
            nv.layer = self.layer
            nv.watch = self.watch
        }
        if let nv = segue.destination as? ColorSelectViewControl {
            nv.editColor = self.layer!.fillColor.Color
            nv.backSegueName = "unwindToImageLayer"
        }
    }
    
    private var imageSize : CGSize = CGSize.init(width: 100, height: 100)
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                self.setImageCell(imageName: self.layer!.imageName, indexPath: indexPath, size: imageSize)
                break
            case 1:
                self.setCheckmarkCell(indexPath: indexPath, checked: layer!.fillWithColor)
                break
            case 2:
                self.setColorCell(color: layer!.fillColor.Color, indexPath: indexPath)
                break
            default:
                break
            }
        }
    }
    
    
    
    @IBAction func unwindToImageLayer(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ImageSelectViewControl {
            layer?.imageName = nv.imageName
            let image = UIImage.init(named: nv.imageName)
            self.setImageCell(image: image!, indexPath: IndexPath.init(row: 0, section: 0), size: imageSize)
            self.watch?.refreshWatch()
        }
        if let nv = unwindSegue.source as? ImageCategoryViewControl {
            if nv.photoImage != nil {
                self.setImageCell(image: nv.photoImage!, indexPath: IndexPath.init(row: 0, section: 0), size: imageSize)
                layer?.imageData = nv.photoImage!.jpegData(compressionQuality: 0.4)
                self.watch?.refreshWatch()
            }
        }
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            self.layer!.fillColor.Color = nv.editColor!
            self.setColorCell(color: layer!.fillColor.Color, indexPath: IndexPath.init(row: 2, section: 0))
            self.watch?.refreshWatch()
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.row == 1) {
            self.layer?.fillWithColor = !self.layer!.fillWithColor
            self.setCheckmarkCell(indexPath: indexPath, checked: layer!.fillWithColor)
            self.watch?.refreshWatch()
        }
    }
    
    private var isOk : Bool = false
    
    @IBAction func DoneButtonClick(_ sender: Any) {
        self.isOk = true
        self.performSegue(withIdentifier: "unwindToLayerManager", sender: self)
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if (parent == nil && !isOk && editRowIndex == -1) {
            self.watch?.deleteLayer(layer: self.layer!)
            self.watch?.refreshWatch()
        }
    }
    
}
