//
//  ImageCategoryVC.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class ImageCategoryViewControl: UITableViewController {

    var imageName: String = ""
    var backSegueName: String = ""

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? ImageSelectViewControl {
            if let cell = sender as? UITableViewCell {
                if let index = self.tableView.indexPath(for: cell) {
                    nv.imageName = self.imageName
                    nv.backSegueName = self.backSegueName
                    switch index.row {
                    case 0:
                        nv.imageList = ResManager.Manager.getImages(category: ResManager.Faces)
                        nv.itemHeight = 82
                        nv.itemWidth = 100
                        break
                    case 1:
                        nv.imageList = ResManager.Manager.getImages(category: ResManager.Logos)
                        nv.itemHeight = 80
                        nv.itemWidth = 80
                        break
                    default:
                        break
                    }
                }
            }
        }
    }
}
