//
//  ThreadUIViewController.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/07.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import UIKit

class ThreadVC: UIViewController {
    
    var entry: NSDictionary? = nil

    @IBOutlet var _id: UILabel?
    @IBOutlet var _date: UILabel?
    @IBOutlet var _title: UILabel?
    @IBOutlet var _user_name: UILabel?

    override func viewDidLoad() {
        if self.entry == nil || self.entry!["title_id"] == nil {
            super.viewDidLoad()
            return
        }
        super.viewDidLoad()
        let title_id = self.entry!["title_id"]! as! Int // castに一貫性がなくJSONParserが怪しい
        get_responses(title_id, { (statusCode, dir) in
            println(dir)
            if dir != nil {
                let id = (dir!["id"]! as! String).toInt()! // でもこうしないと落ちる
                let date = (dir!["date"]! as! String).toInt()! // 気持ち悪い
                let title = dir!["title"]! as! String
                let user_name = dir!["user_name"]! as! String
                let _responses = dir!["responses"]! as! [NSDictionary]
                let responses = _responses.map({(_dir:NSDictionary)-> Response in
                    (
                        date: _dir["date"] as! Int,
                        user_name: _dir["user_name"] as! Int,
                        illust_id: _dir["illust_id"] as! Int,
                        illust_url: _dir["illust_url"] as! Int,
                        like: _dir["like"] as! Int
                    )
                })
                dispatch_async_main{
                    self._id!.text = String(id)
                    self._title!.text = title
                    self._user_name!.text = user_name
                    self._date!.text = String(date)
                }
            }
        })
    }
}
