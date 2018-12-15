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
    
   
    
    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.delegate = self
        
        movieImageView.image = movieImage
        
//        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapImgView(_:)))
//        self.movieImageView.addGestureRecognizer(tapGesture)

        // Do any additional setup after loading the view.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
    // MARK: - Methods
    
//    @objc func tapImgView(_ sender: UITapGestureRecognizer) {
//
//        if self.navigationController?.isNavigationBarHidden == true {
//            self.view.backgroundColor = UIColor.white
//            self.tabBarController?.tabBar.isHidden = false
//            self.navigationController?.isNavigationBarHidden = false
//        } else {
//            self.view.backgroundColor = UIColor.black
//            self.tabBarController?.tabBar.isHidden = true
//            self.navigationController?.isNavigationBarHidden = true
//        }
//
//    }
    
    
    // MARK: IBActions
    
    @IBAction func actionDismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}

extension MovieDetailImageViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return movieImageView
    }
    
}
