//
//  MentionVC.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/08.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import Foundation
import UIKit

class ReactionHeadlineVC: UITableViewController {
    var entries: [Reaction] = []
    var storage:NSUserDefaults = NSUserDefaults()
    
    // UIViewController
    override func viewDidLoad() {
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        let xib = UINib(nibName: "ReactionHeadlineCell", bundle: nil)
        self.tableView?.registerNib(xib, forCellReuseIdentifier: "RHCell")
        super.viewDidLoad()
        let user_id = storage.integerForKey("user_id")
        println("===== user_ID =====")
        println(user_id)
        get_reactions(user_id, {(statusCode, dirs) in
            println("get_reactions")
            println(statusCode)
            println(dirs)
            if dirs != nil {
                let _dirs = dirs! as! [NSDictionary]
                println(_dirs)
                self.entries = _dirs.map({(dir) in
                    println(dir)
                    return (
                        type: dir["type"]! as! Int,
                        date: (dir["date"]! as! String).toInt()!,
                        title: dir["title"]! as! String,
                        title_id: dir["title_id"]! as! Int,
                        illust_id: dir["illust_id"] as? Int
                    )
                })
            }
            dispatch_async_main{
                self.tableView?.reloadData()
            }
        })
    }
    
    // UIViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showThread" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let entry = self.entries[indexPath.row]
                let view = segue.destinationViewController as! ThreadVC
                view.title = entry.title
                view.title_id = entry.title_id
            }
        }
    }
    
    // UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Cellが選択された際に呼び出されるデリゲートメソッド.
        // force segue
        self.performSegueWithIdentifier("showThread", sender: self)
    }
    
    // UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    // UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("RHCell") as! ReactionHeadlineCell
        let entry = entries[indexPath.row]
        cell._title!.text = entry.title
        // リアクションの画像とか
        return cell
    }
}
