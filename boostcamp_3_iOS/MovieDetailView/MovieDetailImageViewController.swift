//
//  MovieDetailImageViewController.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 13/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieDetailImageViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: - Properties
    
    var movieImage: UIImage?
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        movieImageView.image = movieImage
    }
    
    // MARK: - IBActions
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UIScrollViewDelegate

extension MovieDetailImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return movieImageView
    }
    
}
