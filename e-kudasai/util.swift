//
//  util.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/07.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import Foundation
func dispatch_async_main(block: () -> ()) {
    dispatch_async(dispatch_get_main_queue(), block)
}

func dispatch_async_global(block: () -> ()) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
}