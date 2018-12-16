//
//  MovieActorTableViewCell.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 15/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieActorTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var movieDirectorLabel: UILabel!
    @IBOutlet weak var movieActorLabel: UILabel!

    // MARK: - Methods

    func configure(data: MovieDetail) {
        movieDirectorLabel.text = data.director
        movieActorLabel.text = data.actor
    }

}
