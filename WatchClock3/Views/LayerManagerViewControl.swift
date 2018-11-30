//
//  LayerManagerViewControl.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit

class LayerManagerViewControl: UITableViewController {
    var watch : MyWatch?
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.destination)
        if let nv = segue.destination as? AddLayerViewControl {
            nv.watch = self.watch
        }
    }
    
    @IBAction func unwindToLayerManager(_ unwindSegue: UIStoryboardSegue) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.watch?.watchLayers.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCell(withIdentifier: "layeritem") {
            if let layer = self.watch?.getLayer(index: indexPath.row) {
                cell.textLabel?.text = layer.getTitle()
                cell.imageView?.image = layer.getImage()?.getImageWithSize(size: CGSize.init(width: 80, height: 80))
            }
//            cell.textLabel.string =
            return cell
        }
        
        return UITableViewCell()
        
        
    }

}
