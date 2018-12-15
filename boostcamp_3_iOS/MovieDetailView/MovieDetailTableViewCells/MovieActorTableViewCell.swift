//
//  MovieActorTableViewCell.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 15/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieActorTableViewCell: UITableViewCell {
    
    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieActorLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
