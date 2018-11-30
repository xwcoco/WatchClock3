//
//  WatchManagerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/27.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class WatchManagerViewControl: UITableViewController {
    @IBOutlet weak var AddButton: UIBarButtonItem!
    
    @IBOutlet weak var EditButton: UIBarButtonItem!
    @IBAction func EditButtonClick(_ sender: Any) {
//        if self.tableView.isEditing {
//            self.tableView.setEditing(false, animated: true)
//            self.EditButton.title = NSLocalizedString("Edit", comment: "")
//            self.AddButton.isEnabled = true
//        } else {
//            self.tableView.setEditing(true, animated: true)
//            self.EditButton.title = NSLocalizedString("Done", comment: "")
//            self.AddButton.isEnabled = false
//        }
    }
    
    @IBAction func SyncButtonClick(_ sender: Any) {
//        self.SyncWithWatch()
    }

}
