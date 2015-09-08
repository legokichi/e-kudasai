//
//  FirstViewController.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/07.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import UIKit

class ThreadHeadlineTVC: UITableViewController {
    var entries: [NSDictionary] = []
    
    // UIViewController
    override func viewDidLoad() {
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        let xib = UINib(nibName: "ThreadHeadlineCell", bundle: nil)
        self.tableView?.registerNib(xib, forCellReuseIdentifier: "THCell")
        super.viewDidLoad()
        
        get_titles({ (statusCode, dirs) in
            if dirs != nil {
                self.entries = dirs as! [NSDictionary]
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
                view.title = (entry["title"] as! String) ?? "no title"
                view.entry = entry
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
        println(self.tableView.dequeueReusableCellWithIdentifier("THCell")!)
        let cell = self.tableView.dequeueReusableCellWithIdentifier("THCell") as! ThreadHeadlineCell
        let dir = entries[indexPath.row]
        var title = (dir["title"] as! String) ?? "no title"
        cell._title!.text = title
        println("== Hoge ==")
        println(cell._image)
        cell._image?.loadAsyncFromURL("http://www.duxca.com/apple-touch-icon-72x72.png")

        return cell
    }
}
