//
//  FirstViewController.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/07.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import UIKit

class ThreadHeadlineTableViewController: UITableViewController {
    var entries: [NSDictionary] = []
    
    // UIViewController
    override func viewDidLoad() {
        self.tableView?.dataSource = self
        self.tableView?.delegate = self
        
        super.viewDidLoad()
        get_titles({ (statusCode, dirs) in
            if dirs != nil {
                self.entries = dirs as! [NSDictionary]
            }
            dispatch_async_main{
                let xib = UINib(nibName: "ThreadHeadlineCellTableViewCell", bundle: nil)
                self.tableView?.registerNib(xib, forCellReuseIdentifier: "ThreadHeadlineCellTabeleViewCell")
                self.tableView?.reloadData()
            }
        })
    }
    
    // UIViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println(segue.identifier)
        if segue.identifier == "showThread" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let entry = self.entries[indexPath.row]
                println(segue.destinationViewController)
                (segue.destinationViewController as! UIViewController).title = (entry["title"] as! String) ?? "no title"
                (segue.destinationViewController as! ThreadUIViewController).entry = entry
            }
        }
    }
    
    // UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Cellが選択された際に呼び出されるデリゲートメソッド.
        println(indexPath.row)
        self.performSegueWithIdentifier("showThread", sender: self)
    }
    
    // UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries.count
    }
    
    // UITableViewDataSource
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        let dir = entries[indexPath.row]
        var title = ""
        if dir["title"] == nil {
            title = "no title"
        }else{
            title = dir["title"] as! String
        }
        cell.textLabel!.text = title
        return cell
    }
}
