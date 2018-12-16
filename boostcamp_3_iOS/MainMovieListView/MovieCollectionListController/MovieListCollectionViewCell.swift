//
//  MovieListCollectionViewCell.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 09/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieListCollectionViewCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieGradeImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieFullRateLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    
    // MARK: - Methods
    
    func configure(data: MovieList) {
        movieTitleLabel.text = data.title
        movieFullRateLabel.text = data.cFullRate
        movieDateLabel.text = data.date
        movieGradeImageView.image = UIImage(named: data.gradeImageString)
        movieImageView.image = #imageLiteral(resourceName: "img_placeholder")
    }
    
}
