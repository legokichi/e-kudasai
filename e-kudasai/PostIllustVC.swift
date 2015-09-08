//
//  PostIllustVC.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/08.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import Foundation
import UIKit

class PostIllustVC: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var _img: UIImageView!
    var title_id: Int? = nil
    var _data: NSData? = nil
    
    var storage: NSUserDefaults = NSUserDefaults()
    
    @IBAction func tapPost(sender : AnyObject) {
        if self._data == nil {
            return
        }
        let user_id = storage.integerForKey("user_id")
        post_illust(self.title_id!, user_id, "anonymous", self._data!, {(statusCode, dir) in
            println(dir)
            dispatch_async_main{
                self.navigationController!.popViewControllerAnimated(true)!
            }
        })
    }
    
    @IBAction func tapButton(sender : AnyObject) {
        var sheet: UIActionSheet = UIActionSheet()
        let title: String = "どうするん？"
        sheet.title = title
        sheet.delegate = self
        sheet.addButtonWithTitle("諦める")
        sheet.addButtonWithTitle("写真を撮る")
        sheet.addButtonWithTitle("カメラロールから選択")
        
        // キャンセルボタンのindexを指定
        sheet.cancelButtonIndex = 0
        
        // UIActionSheet表示
        sheet.showInView(self.view)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func actionSheet(sheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("index %d %@", buttonIndex, sheet.buttonTitleAtIndex(buttonIndex))
        switch buttonIndex {
        case 1:
            pickImageFromCamera()
        case 2:
            pickImageFromLibrary()
        default:
            break
        }
    }
    
    func pickImageFromCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // ライブラリから写真を選択する
    func pickImageFromLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(controller, animated: true, completion: nil)
        }
    }
    
    // 写真を選択した時に呼ばれる
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if info[UIImagePickerControllerOriginalImage] != nil {
            // 画像データの取得
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let data = UIImageJPEGRepresentation(image, 0.8)
            
            // 画像データをTag:1 の UIImageView にセット
            _img!.image = image
            
            self._data = data
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        println(segue.identifier)
        if (segue.identifier == "next") {
            // pass data to next view
        }
    }

}