//
//  WatchManagerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/27.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class WatchManagerViewControl: UITableViewController {
    @IBOutlet weak var AddButton: UIBarButtonItem!

    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBAction func EditButtonClick(_ sender: Any) {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
            self.EditButton.title = NSLocalizedString("Edit", comment: "")
            self.AddButton.isEnabled = true
        } else {
            self.tableView.setEditing(true, animated: true)
            self.EditButton.title = NSLocalizedString("Done", comment: "")
            self.AddButton.isEnabled = false
        }
    }

    @IBAction func SyncButtonClick(_ sender: Any) {
//        self.SyncWithWatch()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WatchManager.Manager.WatchList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "watchitemcell") {
                if let skview: SKView = cell.contentView.subviews[1] as? SKView {
                    if let watch = WatchManager.Manager.getWatch(index: indexPath.row) {
                        watch.scene.camera?.xScale = 1.8 / (184.0 / skview.bounds.width)
                        watch.scene.camera?.yScale = 1.8 / (224.0 / skview.bounds.height)
                        skview.presentScene(watch.scene)
                    }
                }

                return cell
            }
        }
        return UITableViewCell()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? WatchSettingsViewControl {
            if (sender as? UIButton) != nil {
                nv.editRowIndex = -1
            } else {
                if let cell = sender as? UITableViewCell {
                    if let index = self.tableView.indexPath(for: cell) {
                        nv.editRowIndex = index.row
                        nv.setEditWatch(watchData: WatchManager.Manager.WatchList[index.row])
                    }
                    
                }
            }
        }
    }

    private func addWatch(watchData: String) {
        let watchNum = WatchManager.Manager.WatchList.count
        WatchManager.Manager.addWatch(watchData: watchData)
        self.tableView.insertRows(at: [IndexPath.init(row: watchNum, section: 0)], with: .automatic)
    }

    @IBAction func unwindToWatchManager(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? WatchSettingsViewControl {
            if nv.editRowIndex == -1 {
                let jsonData = nv.watch.toJSON()
                print(jsonData)
                self.addWatch(watchData: jsonData)
            } else {
                let jsonData = nv.watch.toJSON()
                print(jsonData)
                WatchManager.Manager.updateWatch(index: nv.editRowIndex, watchData: jsonData)
                if let skview = self.getSkView(indexPath: IndexPath.init(row: nv.editRowIndex, section: 0)) {
                    let watch = WatchManager.Manager.getWatch(index: nv.editRowIndex)
                    watch!.scene.camera?.xScale = 1.8 / (184.0 / skview.bounds.width)
                    watch!.scene.camera?.yScale = 1.8 / (224.0 / skview.bounds.height)
                    skview.presentScene(watch?.scene)
                }
            }
        }

    }
    
    private func getSkView(indexPath : IndexPath) -> SKView? {
        if let cell = self.tableView.getCell(at: indexPath) {
            return cell.contentView.subviews[1] as? SKView
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            WatchManager.Manager.deleteWatch(index: indexPath.row)
            self.tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        WatchManager.Manager.WatchList.swapAt(sourceIndexPath.row, destinationIndexPath.row)
//        self.watch?.watchLayers.swapAt(sourceIndexPath.row, destinationIndexPath.row)
//        self.watch?.refreshWatch()
    }

    
    
}
