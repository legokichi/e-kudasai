//
//  ThreadUIViewController.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/07.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import UIKit

class ThreadVC: UIViewController {
    
    var title_id: Int? = nil
    var date: Int? = nil
    var _title_: String? = nil
    var user_name: String? = nil
    var responses: [Response] = []
    var storage: NSUserDefaults = NSUserDefaults()
    
    @IBOutlet var _id: UILabel?
    @IBOutlet var _date: UILabel?
    @IBOutlet var _title: UILabel?
    @IBOutlet var _user_name: UILabel?
    
    @IBAction func tapButton(sender : AnyObject) {}
    
    // UIViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showPostPage" {
            let view = segue.destinationViewController as! PostIllustVC
            view.title_id = self.title_id!
        }
    }
    
    // UIViewController
    override func viewDidLoad() {
        if self.title_id == nil {
            super.viewDidLoad()
            return
        }
        super.viewDidLoad()
        get_responses(self.title_id!, { (statusCode, dir) in
            dispatch_async_main{
                if dir != nil {
                    //id = (dir!["id"]! as! String).toInt()!
                    self.date = (dir!["date"]! as! String).toInt()!
                    self._title_ = dir!["title"]! as! String
                    self.user_name = dir!["user_name"]! as! String
                    let _responses = dir!["responses"]! as! [NSDictionary]
                    self.responses = _responses.map({(_dir) in
                        println(_dir)
                        return (
                            date: (_dir["date"]! as! String).toInt()!,
                            user_name: _dir["user_name"]! as! String,
                            illust_id: _dir["illust_id"]! as! Int,
                            likes: _dir["likes"]! as! Int
                        )
                    })
                    self._id!.text = "\(self.title_id!)"
                    self._title!.text = self._title_
                    self._user_name!.text = self.user_name
                    self._date!.text = "\(self.date!)"
                }
            }
        })
    }
}
