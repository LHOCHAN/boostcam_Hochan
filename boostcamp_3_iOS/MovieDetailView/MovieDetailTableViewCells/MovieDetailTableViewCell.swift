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

    @IBOutlet weak var starRatingControl: StarRatingControl!
    
    // MARK: - Properties
    
    var imageTapClosure: (() -> Void)?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImgView(_:)))
        self.movieImageView.addGestureRecognizer(tapGesture)
        
        
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // MARK: - Methods
    
    @objc func tapImgView(_ sender: UITapGestureRecognizer) {
        imageTapClosure?()
    }
    
}
