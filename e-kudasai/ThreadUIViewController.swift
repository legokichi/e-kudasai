//
//  ThreadUIViewController.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/07.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import UIKit

typealias Response = (
    date: Int,
    user_name: Int,
    illust_id: Int,
    illust_url: Int,
    like: Int
)

class ThreadUIViewController: UIViewController {
    var entry: NSDictionary? = nil

    override func viewDidLoad() {
        if self.entry == nil || self.entry!["title_id"] == nil {
            super.viewDidLoad()
            return
        }
        super.viewDidLoad()
        let title_id = self.entry!["title_id"]! as! Int // castに一貫性がなくJSONParserが怪しい
        get_responses(title_id, { (statusCode, dir) in
            println(statusCode)
            println(dir)
            if dir != nil {
                let id = (dir!["id"]! as! String).toInt()! // でもこうしないと落ちる
                let date = (dir!["date"]! as! String).toInt()! // 気持ち悪い
                let title = dir!["title"]! as! String
                let user_name = dir!["user_name"]! as! String
                let responses = dir!["responses"]! as! [NSDictionary]
                let _res = responses.map({(_dir:NSDictionary)-> Response in
                    (
                        date: _dir["date"] as! Int,
                        user_name: _dir["user_name"] as! Int,
                        illust_id: _dir["illust_id"] as! Int,
                        illust_url: _dir["illust_url"] as! Int,
                        like: _dir["like"] as! Int
                    )
                })
            }
        })

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
