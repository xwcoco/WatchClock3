//
//  WatchCollectionCategoryViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/6.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchCollectionCategroyViewControl : UITableViewController,WatchCollectionCellDelegate {
    func WatchCollectionClick(_ row: Int) {
        if let cell = self.tableView.getCell(at: IndexPath.init(row: row, section: 0)) {
            if let skview = cell.contentView.subviews[0] as? SKView {
                if let sence = skview.scene as? WatchScene {
                    let json = sence.watch?.toJSON()
                    NotificationCenter.default.post(name: Notification.Name("WatchCollectionAddWatch"), object: json)
                    self.tabBarController?.view.makeToast("表盘已放入我的手表列表中")

                }
            }
        }

    }
    
    public var categroy : String = ""
    
    private var watchList : [MyWatch] = []
    
    override func viewDidLoad() {
        if self.categroy != "" {
            self.watchList = WatchCollectionManager.Manager.getWatchList(key: categroy)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watchList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "watchcollectionitem")
        cell?.tag = indexPath.row
        (cell as? WatchCollectionCell)!.delegate = self
        
        let watch = self.watchList[indexPath.row]
        if let skview = cell!.contentView.subviews[0] as? SKView {
            watch.BeginUpdate()
            watch.EndUpdate()
            watch.scene.camera?.xScale = 1.9 / (184.0 / skview.bounds.width)
            watch.scene.camera?.yScale = 1.9 / (224.0 / skview.bounds.height)
            skview.presentScene(watch.scene)
            skview.alpha = 1

        }
        
        watch.isDemoMode = true
//        watch.isPaused = true
        
        
        return cell!

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.getCell(at: indexPath)
        if let skview = cell!.contentView.subviews[0] as? SKView {
            if let sence = skview.scene as? WatchScene {
                sence.watch?.isDemoMode = false
                sence.watch?.isPaused = false
                skview.isPaused = false
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
        let cell = self.tableView.getCell(at: indexPath)
        if let skview = cell!.contentView.subviews[0] as? SKView {
            if let sence = skview.scene as? WatchScene {
                sence.watch?.isDemoMode = true
//                sence.watch?.isPaused = true
//                skview.isPaused = true
            }
        }

        return indexPath
    }
    
}

protocol WatchCollectionCellDelegate {
    func WatchCollectionClick(_ row : Int) -> Void
}

class WatchCollectionCell : UITableViewCell {
    
    var delegate : WatchCollectionCellDelegate?
    @IBAction func addButtonClick(_ sender: Any) {
        self.delegate?.WatchCollectionClick(self.tag)
    }
}
