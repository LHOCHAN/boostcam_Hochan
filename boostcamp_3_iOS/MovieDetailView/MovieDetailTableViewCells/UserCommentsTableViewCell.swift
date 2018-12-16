//
//  UserCommentsTableViewCell.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 11/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class UserCommentsTableViewCell: UITableViewCell {

    // MARK: - IBOutlets

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userContentsLabel: UILabel!
    @IBOutlet weak var starRatingControl: StarRatingControlView!
    
    // MARK: - Methods

    func configure(data: UserComment) {
        userNameLabel.text = data.writer
        userContentsLabel.text = data.contents
        dateLabel.text = data.timestampFormatted
        starRatingControl.rating = data.rating
    }
    
}
