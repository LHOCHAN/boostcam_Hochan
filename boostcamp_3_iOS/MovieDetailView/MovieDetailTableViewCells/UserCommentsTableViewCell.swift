//
//  UserCommentsTableViewCell.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 11/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class UserCommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userContentsLabel: UILabel!
    @IBOutlet weak var starRatingControl: StarRatingControl!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
