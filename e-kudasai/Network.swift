//
//  Network.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/07.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import Foundation

// see also
// https://github.com/pixiv/summer-intern-2015-a
// https://github.com/pixiv/summer-intern-2015-a-server

// ===========

typealias User = (
    user_id: Int,
    date: Int
)

typealias Response = (
    date: Int,
    user_name: Int,
    illust_id: Int,
    illust_url: Int,
    like: Int
)

typealias Reaction = (
    id: Int,
    date: Int,
    title: String,
    user_name: Int,
    responses: [Response]
)

typealias Title = (
    title_id: Int,
    date: Int,
    user_name: String,
    title: String,
    illusts : [String],
    count: Int
)

typealias Illust = (
    date: Int,
    user_name: String,
    illust_id: Int,
    illust_url: String
)

typealias Favolite = User


let baseURL = "http://133.242.234.139/api/"

func register_new_user(callback: (Int, NSDictionary?) -> Void ) -> Void {
    getJSONObject(baseURL+"register_new_user.php", callback)
}

func get_titles(callback: (Int, NSArray?) -> Void ) -> Void {
    getJSONArray(baseURL+"get_titles.php", callback)
}

func get_responses(title_id: Int, callback: (Int, NSDictionary?) -> Void ) -> Void {
    getJSONObject(baseURL+"get_responses.php?title_id=\(title_id)", callback)
}

func get_reactions(user_id: Int, callback: (Int, NSArray?) -> Void ) -> Void {
    getJSONArray(baseURL+"get_reactions.php?user_id=\(user_id)", callback)
}

func post_title(user_id: Int, title: String, callback: (Int, NSDictionary?) -> Void ) -> Void {
    post(
        baseURL+"post_title.php",
        [
            ("user_id", "text/plain", "\(user_id)".dataUsingEncoding(NSUTF8StringEncoding)!),
            ("title", "text/plain", title.dataUsingEncoding(NSUTF8StringEncoding)!)
        ],
        {(statusCode, data) in
            if (statusCode != 200){
                callback(statusCode, nil)
                return
            }
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions.MutableContainers,
                error: &err
                ) as? NSDictionary
            if (err != nil) {
                callback(-2, json)
            }
            callback(statusCode, json)
        }
    )
}

func post_illust(title_id: Int, user_id: Int, rawJPG: NSData, callback: (Int, NSDictionary?) -> Void ) -> Void {
    post(
        baseURL+"post_illust.php",
        [
            ("title_id",    "text/plain", "\(title_id)".dataUsingEncoding(NSUTF8StringEncoding)!),
            ("user_id",  "text/plain", "\(user_id)".dataUsingEncoding(NSUTF8StringEncoding)!),
            ("file", "image/jpeg", rawJPG)
        ],
        {(statusCode, data) in
            if (statusCode != 200){
                callback(statusCode, nil)
                return
            }
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions.MutableContainers,
                error: &err
                ) as? NSDictionary
            if (err != nil) {
                callback(-2, json)
            }
            callback(statusCode, json)
        }
    )
}

func post_favorite(illust_id: Int, callback: (Int, NSDictionary?) -> Void ) -> Void {
    post(
        baseURL+"favorite.php",
        [("illust_id",    "text/plain", "\(illust_id)".dataUsingEncoding(NSUTF8StringEncoding)!)],
        {(statusCode, data) in
            if (statusCode != 200){
                callback(statusCode, nil)
                return
            }
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions.MutableContainers,
                error: &err
                ) as? NSDictionary
            if (err != nil) {
                callback(-2, json)
            }
            callback(statusCode, json)
        }
    )
}


// ===========


func getJSONArray(url: String, callback: (Int, NSArray?) -> Void ) -> Void {
    get(
        url,
        {(statusCode, data) in
            if (statusCode != 200){
                callback(statusCode, nil)
                return
            }
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions.MutableContainers,
                error: &err
                ) as? NSArray
            if (err != nil) {
                callback(-2, json)
            }
            callback(statusCode, json)
        }
    )
}


func getJSONObject(url: String, callback: (Int, NSDictionary?) -> Void ) -> Void {
    get(
        url,
        {(statusCode, data) in
            if (statusCode != 200){
                callback(statusCode, nil)
                return
            }
            var err: NSError?
            var json = NSJSONSerialization.JSONObjectWithData(
                data,
                options: NSJSONReadingOptions.MutableContainers,
                error: &err
                ) as? NSDictionary
            if (err != nil) {
                callback(-2, json)
            }
            callback(statusCode, json)
        }
    )
}


// ===========



func get(url: String, callback: (Int, NSData!) -> Void) -> Void {
    var req = NSMutableURLRequest()
    req.URL = NSURL(string: url)
    req.HTTPMethod = "GET"
    
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    var task = session.dataTaskWithRequest(
        req,
        completionHandler: {(data:NSData!, res:NSURLResponse!, err:NSError!)-> Void in
            if (err != nil) {
                println(err)
                callback(-1, nil)
                return
            }
            let httpResponse = res as? NSHTTPURLResponse
            let statusCode = httpResponse!.statusCode;
            if(statusCode != 200){
                callback(httpResponse!.statusCode, nil)
                println(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                return
            }
            println(NSString(data: data, encoding: NSUTF8StringEncoding)!)
            callback(httpResponse!.statusCode, data)
        }
    )
    task.resume()
}


func post(url: String, params:[(String, String, NSData)], callback: (Int, NSData!) -> Void) -> Void {
    var req = NSMutableURLRequest()
    req.URL = NSURL(string: url)
    req.HTTPMethod = "POST"
    let boundary = "----teamApple" + String(arc4random() % 10000000)
    var body = NSMutableData()
    var _key = ""
    var i = 0
    
    for (key, type, val) in params {
        if type == "image/jpeg" { _key = key+"\"; " + "filename=\"hoge" } else { _key = key }
        let headStr = [
            "--\(boundary)",
            "Content-Disposition: form-data; name=\"\(_key)\"",
            "Content-Type: \(type)",
            ""
            ].reduce("", combine:{(sum, str) in sum + str + "\r\n" })
        body.appendData(headStr.dataUsingEncoding(NSUTF8StringEncoding)!)
        body.appendData(val)
        body.appendData("\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
    }
    body.appendData("--\(boundary)--".dataUsingEncoding(NSUTF8StringEncoding)!)
    req.setValue("multipart/form-data; charaset=utf-8; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    req.setValue(String(body.length), forHTTPHeaderField: "Content-Length")
    req.HTTPBody = NSData(data:body)
    
    //println(NSString(data:body, encoding:NSUTF8StringEncoding)!)
    
    let config = NSURLSessionConfiguration.defaultSessionConfiguration()
    let session = NSURLSession(configuration: config)
    var task = session.dataTaskWithRequest(
        req,
        completionHandler: {(data:NSData!, res:NSURLResponse!, err:NSError!)-> Void in
            if (err != nil) {
                println(err)
                callback(-1, nil)
                return
            }
            let httpResponse = res as? NSHTTPURLResponse
            let statusCode = httpResponse!.statusCode;
            if(statusCode != 200){
                println(httpResponse)
                println(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                callback(httpResponse!.statusCode, nil)
                return
            }
            println(NSString(data: data, encoding: NSUTF8StringEncoding)!)
            callback(httpResponse!.statusCode, data)
        }
    )
    task.resume()
}


// examples
    // statusCode: -1 network error
    // statusCode: -2 json parse error
    /*
    register_new_user({ (statusCode, dir) in
    println("register_new_user")
    println(statusCode)
    println(dir)
    if dir != nil {
    print(dir!["user_id"])
    }
    })
    */
    /*
    get_titles({ (statusCode, dirs) in
    println("get_titles")
    println(statusCode)
    println(dirs)
    if dirs != nil {
    println(dirs!)
    }
    })*/
    
    /*
    let title_id = 2
    get_responses(title_id, { (statusCode, dir) in
    println("get_responses")
    println(statusCode)
    println(dir)
    })*/
    
    /*
    let user_id = 3
    get_reactions(user_id, {(statusCode, dirs) in
        println("get_reactions")
        println(statusCode)
        println(dirs)
    })
    */
    
    /*
    let user_id = 4
    let title = "ふたなり瑞鶴ください！！！!"
    post_title(user_id, title, {(statusCode, dir) in
    println("post_title")
    println(statusCode)
    println(dir)
    })*/
    
    
    /*
    let user_id2 = 3
    let title_id2 = 2
    let path : String = NSBundle.mainBundle().pathForResource("COJqvouVEAA_6dS", ofType: "jpg")!
    let fileHandle = NSFileHandle(forReadingAtPath: path)!
    let data : NSData = fileHandle.readDataToEndOfFile()
    
    post_illust(title_id2, user_id2, data, { (statusCode, dir) in
    println("post_illust")
    println(statusCode)
    println(dir)
    })
    */
    
    
    /*
    let illust_id = 3
    post_favorite(illust_id, { (statusCode, dir) in
    println("post_favorite")
    println(statusCode)
    println(dir)
    })
    */
    
    // playground only
