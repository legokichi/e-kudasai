//
//  util.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/07.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import Foundation
import UIKit

func dispatch_async_main(block: () -> ()) {
    dispatch_async(dispatch_get_main_queue(), block)
}

func dispatch_async_global(block: () -> ()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}

func typeof<T>(a: T)-> String {
    return "\(a.dynamicType)"
}

extension UIImageView {
    func loadAsyncFromURL(urlString: String) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), {
            let url = NSURL(string: urlString)
            var err: NSError?
            let imageData = NSData(contentsOfURL: url!, options: NSDataReadingOptions.DataReadingMappedIfSafe, error: &err)
            var image: UIImage?
            if let _data = imageData {
                image = UIImage(data: _data)
                
                dispatch_async(dispatch_get_main_queue(), {
                    self.image = image
                })
            }
        })
    }
}