//
//  StarRatingControl.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 12/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class StarRatingControlView: UIStackView {

    // MARK: - Properties
    
    private var ratingImages = [UIImageView]()
    
    var rating: Double = 0 {
        didSet {
            self.setupStars()
            self.updateStarImageStates()
            
        }
    }
    
    // MARK: - Private Methods
    
    // Add ImageView to StackView
    private func setupStars() {
        for _ in 0..<5 {
            let imageView = UIImageView()
            imageView.translatesAutoresizingMaskIntoConstraints = false
            addArrangedSubview(imageView)
            ratingImages.append(imageView)
        }
    }
    
    private func updateStarImageStates() {
        var rateCal = rating / 2
        
        for index in 0..<5 {
            if rateCal < 0.5 {
                ratingImages[index].image = UIImage(named:"ic_star_large")
            } else if 0.5 <= rateCal && rateCal < 1 {
                ratingImages[index].image = UIImage(named:"ic_star_large_half")
            } else {
                ratingImages[index].image = UIImage(named: "ic_star_large_full")
            }
            rateCal -= 1
        }
    }

}
