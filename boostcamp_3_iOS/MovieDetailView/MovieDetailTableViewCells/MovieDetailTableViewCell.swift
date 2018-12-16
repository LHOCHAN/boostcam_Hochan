//
//  MovieDetailHeaderTableViewCell.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 11/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieDetailTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieGradeImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieDateLabel: UILabel!
    @IBOutlet weak var movieGenreDurationLabel: UILabel!
    @IBOutlet weak var movieReserveGradeRateLabel: UILabel!
    @IBOutlet weak var movieAudienceLabel: UILabel!
    @IBOutlet weak var movieRatingLabel: UILabel!
    @IBOutlet weak var starRatingControl: StarRatingControlView!
    
    // MARK: - Properties
    
    var imageTapClosure: (() -> Void)?
    
    // MARK: - LifeCycles

    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImgView(_:)))
        self.movieImageView.addGestureRecognizer(tapGesture)
    }
    
    // MARK: - Methods
    
    func configure(data: MovieDetail) {
        movieTitleLabel.text = data.title
        movieDateLabel.text = data.date
        movieGradeImageView.image = UIImage(named: data.gradeImageString)
        movieGenreDurationLabel.text = data.genreDuration
        movieRatingLabel.text = String(data.userRating)
        movieReserveGradeRateLabel.text = data.reservationGradeRate
        movieImageView.image = #imageLiteral(resourceName: "img_placeholder")
        starRatingControl.rating = data.userRating
        movieAudienceLabel.text = data.audienceFormatted
    }
    
    @objc func tapImgView(_ sender: UITapGestureRecognizer) {
        imageTapClosure?()
    }
    
}
