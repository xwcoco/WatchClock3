//
//  WatchSetupViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/1.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class WatchSetupViewControl: UITableViewController {
    var watch : MyWatch?
    
    private var ColorImageSize : CGSize = CGSize.init(width: 40, height: 40)
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0) {
            self.setColorCell(color: watch!.Settings.backgroundColor.Color, indexPath: indexPath, size: ColorImageSize)
        }
        if (indexPath.section == 1) {
            if indexPath.row == 0 {
                if watch!.Settings.showColorRegion {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
            if (indexPath.row == 1) {
                self.setColorCell(color: watch!.Settings.ColorRegionColor.Color, indexPath: indexPath, size: ColorImageSize)
            }
        }
        if (indexPath.section == 2) {
            if watch!.Settings.smoothHand {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 1:
            if indexPath.row == 0 {
               let cell = tableView.cellForRow(at: indexPath)!
                if cell.accessoryType == .checkmark {
                    cell.accessoryType = .none
                    watch!.Settings.showColorRegion = false
                    watch!.refreshWatch()
                } else {
                    cell.accessoryType = .checkmark
                    watch!.Settings.showColorRegion = true
                    watch!.refreshWatch()
                }
            }
            break
        case 2:
            let cell = tableView.cellForRow(at: indexPath)!
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
            } else {
                cell.accessoryType = .checkmark
            }
            watch!.Settings.smoothHand = cell.accessoryType == .checkmark
            watch?.refreshWatch()
        default:
            break
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nv = segue.destination as? ColorSelectViewControl {
            if let cell = sender as? UITableViewCell {
                let index = self.tableView.indexPath(for: cell)!
                switch index.section {
                case 0:
                    nv.editColor = watch!.Settings.backgroundColor.Color
                    break
                case 1:
                    nv.editColor = watch!.Settings.ColorRegionColor.Color
                default:
                    break
                }
                nv.editIndexPath = index
                nv.backSegueName = "unwindToWatchSetup"
            }
        }
    }
    
    @IBAction func unwindToWatchSetup(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? ColorSelectViewControl {
            switch nv.editIndexPath!.section {
            case 0:
                self.watch!.Settings.backgroundColor.Color = nv.editColor!
                self.setColorCell(color: nv.editColor!, indexPath: IndexPath.init(row: 0, section: 0),size : ColorImageSize)
                break
            default:
                self.watch!.Settings.ColorRegionColor.Color = nv.editColor!
                self.setColorCell(color: nv.editColor!, indexPath: nv.editIndexPath!, size: ColorImageSize)
            }
            self.watch?.refreshWatch()
        }
    }
}
