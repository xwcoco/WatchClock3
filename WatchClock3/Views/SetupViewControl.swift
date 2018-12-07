//
//  SetupViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/12/7.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class SetupViewControl: UITableViewController {
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if (indexPath.section == 0 && indexPath.row == 0) {
            cell.detailTextLabel?.text = WatchManager.Manager.WeatherCityName
        }
    }
    
    @IBAction func unwindToSetup(_ unwindSegue: UIStoryboardSegue) {
        if let nv = unwindSegue.source as? WeatherLocationViewControl {
            WatchManager.Manager.WeatherLocation = nv.Location
            WatchManager.Manager.WeatherCityName = nv.CityName
            WatchManager.Manager.saveWatchToFile()
            let cell = self.tableView.getCell(at: IndexPath.init(row: 0, section: 0))
            cell?.detailTextLabel?.text = WatchManager.Manager.WeatherCityName
            NotificationCenter.default.post(name: Notification.Name("WeatherLocationChanged"), object: self)
        }
    }
}
