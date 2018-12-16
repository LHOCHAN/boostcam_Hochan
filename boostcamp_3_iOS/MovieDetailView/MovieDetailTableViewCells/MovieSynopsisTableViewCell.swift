//
//  MovieSynopsisTableViewCell.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 15/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieSynopsisTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets

    @IBOutlet weak var movieSynopsisLabel: UILabel!
    
    // MARK: - Methods

    func configure(data: MovieDetail) {
        movieSynopsisLabel.text = data.synopsis
    }
    
}
