//
//  IllustCell.swift
//  e-kudasai
//
//  Created by yohsukeino on 2015/09/08.
//  Copyright (c) 2015年 duxca. All rights reserved.
//

import UIKit

class IllustCell: UITableViewCell {
    @IBOutlet weak var _like_n: UILabel!
    @IBOutlet weak var _date: UILabel!
    @IBOutlet weak var _user_name: UILabel!
    @IBOutlet weak var _image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
