//
//  WatchSettingsViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchSettingsViewControl: UITableViewController {
    var watch : MyWatch = MyWatch()
    
    var editRowIndex : Int = -1
    
    func setEditWatch(watchData : String) -> Void {
        let tmpwath = MyWatch.fromJSON(data: watchData)
        if (tmpwath != nil) {
            self.watch = tmpwath!
            self.watch.BeginUpdate()
            self.watch.EndUpdate()
        }
    }
    
    override func viewDidLoad() {
//        self.testFromJson()
        self.setDemoWatch()
    }
    
    func setDemoWatch() -> Void {
        if let cell: UITableViewCell = self.tableView.getCell(at: IndexPath(row: 0, section: 0)) {
            if let skview: SKView = cell.contentView.subviews[1] as? SKView {
                if (skview.scene == nil) {
                    watch.scene.camera?.xScale = 1.8 / (184.0 / skview.bounds.width)
                    watch.scene.camera?.yScale = 1.8 / (224.0 / skview.bounds.height)
                    
                    skview.presentScene(watch.scene)
//                    skview.showsDrawCount = true
//                    skview.showsNodeCount = true
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 200
        }
        
        return UIScreen.main.bounds.height - 400
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? UINavigationController {
            
            if let fs = nv.topViewController as? LayerManagerViewControl {
                fs.watch = self.watch
            }
        }
    }
    
    @IBAction func unwindToWatchSettings(_ unwindSegue: UIStoryboardSegue) {
        // Use data from the view controller which initiated the unwind segue
    }

    @IBAction func DoneButtonClick(_ sender: Any) {
        self.performSegue(withIdentifier: "unwindToWatchManager", sender: self)
    }
    
}



extension UITableView {
    func getCell(at: IndexPath) -> UITableViewCell? {
        //当列表太多时，一行未显示，cellforRow 会返回 nil
        var cell = self.cellForRow(at: at)
        if (cell == nil) {
            cell = self.dataSource?.tableView(self, cellForRowAt: at)
        }
        return cell
    }
}



