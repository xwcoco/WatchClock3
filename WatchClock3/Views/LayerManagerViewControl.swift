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
        if let nv = segue.destination as? AddLayerViewControl {
            nv.watch = self.watch
        }
        if let nv = segue.destination as? WatchSetupViewControl {
            nv.watch = self.watch
        }
        if let cell = sender as? UITableViewCell {
            let index = self.tableView.indexPath(for: cell)!
            let layer = self.watch?.getLayer(index: index.row)
            if let nv = segue.destination as? ImageLayerViewControl {
                nv.watch = self.watch
                nv.layer = layer as? ImageLayer
                nv.editRowIndex = index.row
            }
            else if let nv = segue.destination as? HourLayerViewControl {
                nv.watch = self.watch
                nv.layer = layer as? HourLayer
                nv.editRowIndex = index.row
            } else if let nv = segue.destination as? TickMarkLayerViewControl {
                nv.watch = self.watch
                nv.layer = layer as? TickMarkLayer
                nv.editRowIndex = index
            }
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
            return cell
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let layer = self.watch?.getLayer(index: indexPath.row) {
            if layer is HourLayer {
                self.performSegue(withIdentifier: "showHourLayer", sender: self.tableView.cellForRow(at: indexPath))
            } else if layer is ImageLayer {
                self.performSegue(withIdentifier: "showImageLayer", sender: self.tableView.cellForRow(at: indexPath))
            } else if layer is TickMarkLayer {
                self.performSegue(withIdentifier: "showTickMarkLayer", sender: self.tableView.cellForRow(at: indexPath))
            }
        }
        
    }
    
    private var isLoading : Bool = false
    override func viewDidLoad() {
            self.isLoading = true
    }
    
    override func didMove(toParent parent: UIViewController?) {
        if let nv = parent as? UINavigationController {
            if nv.topViewController is LayerManagerViewControl {
                if isLoading {
                    isLoading = false
                    return
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func EditButtonClick(_ sender: Any) {
        if self.tableView.isEditing {
            self.tableView.setEditing(false, animated: true)
        } else {
            self.tableView.setEditing(true, animated: true)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.watch?.deleteLayer(index: indexPath.row)
            self.tableView.reloadData()
            self.watch?.refreshWatch()
        }
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.watch?.watchLayers.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        self.watch?.refreshWatch()
    }
    
}
