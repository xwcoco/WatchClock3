//
//  ImageCategoryVC.swift
//  WatchClock3
//
//  Created by 徐卫 on 2018/11/29.
//  Copyright © 2018 xwcoco. All rights reserved.
//

import Foundation
import UIKit
import Photos
import MobileCoreServices

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
                    case 2:
                        nv.imageList = ResManager.Manager.getImages(category: ResManager.InfoDateBack)
                        nv.itemHeight = 60
                        nv.itemWidth = 60

                    default:
                        break
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 3) {
            self.selectFromPhoto()
        }
    }
    
//    lazy var picker = UIImagePickerController()
    
//    func pickUpImage() -> Void {
//        picker.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
//            picker.allowsEditing = true
//            self.present(picker,animated: true, completion: nil)
//        }
        
//    }
    
    var photoImage : UIImage?
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
////        self.photoImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
//        self.photoImage =  info[UIImagePickerController.InfoKey.]
//        self.performSegue(withIdentifier: self.backSegueName, sender: self)
//    }
//
//    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        self.picker.dismiss(animated: true, completion: nil)
//    }
    
        private func selectFromPhoto(){
            PHPhotoLibrary.requestAuthorization {[unowned self] (status) -> Void in
                DispatchQueue.main.async {
                    switch status {
                    case .authorized:
                        self.showLocalPhotoGallery()
                        break
                    default:
                        self.showNoPermissionDailog()
                        break
                    }
                }
            }
        }
    //
        private func showLocalPhotoGallery(){
            KiClipperHelper.sharedInstance.nav = self.navigationController
            KiClipperHelper.sharedInstance.clippedImgSize = CGSize.init(width: 324, height: 394)
            KiClipperHelper.sharedInstance.clipperType = .Move
            KiClipperHelper.sharedInstance.systemEditing = false
            KiClipperHelper.sharedInstance.clippedImageHandler = {[weak self]img in
                self?.photoImage =  img.resizeImage(targetSize: CGSize.init(width: 324, height: 394))
//                self?.photoImage = img
//                print(self!.photoImage!.size)
                
                self?.performSegue(withIdentifier: self!.backSegueName, sender: self)
            }
            KiClipperHelper.sharedInstance.photoWithSourceType(type: .photoLibrary) //直接打开相册选取图片
        }
    //
    //
    //    /**
    //     * 用户相册未授权，Dialog提示
    //     */
        private func showNoPermissionDailog(){
            let alert = UIAlertController.init(title: nil, message: "没有打开相册的权限", preferredStyle: .alert)
            alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    //
    ////    /**
    ////     * 打开本地相册列表
    ////     */
    ////    private func showLocalPhotoGallery(){
    //////        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
    //////            //初始化图片控制器
    //////            let picker = UIImagePickerController()
    //////            //设置代理
    //////            picker.delegate = self
    //////            //指定图片控制器类型
    //////            picker.sourceType = UIImagePickerController.SourceType.photoLibrary
    //////            //设置是否允许编辑
    //////            picker.allowsEditing = true
    //////            //弹出控制器，显示界面
    //////            self.present(picker, animated: true, completion: {
    //////                () -> Void in
    //////            })
    //////        }else{
    //////            print("读取相册错误")
    //////        }
    ////    }
    //

    
}
