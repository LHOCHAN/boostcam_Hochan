//
//  MovieDetailViewController.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 11/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    let cellIdentifier = "UserCommentsTableViewCell"

    var id: String?
    var movieName: String?
    var movieDetail: MovieDetail?
    var userCommentArr: [UserComment] = [UserComment]()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MovieDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailTableViewCell")
        tableView.tableFooterView?.backgroundColor = UIColor.gray

//        self.navigationController?.navigationBar.topItem?.title = "영화목록"
        self.navigationItem.title = movieName
        
        activityIndicator.startAnimating()
        
        getMovieDetailData()
        getUserCommentsData()
        
        
        // Do any additional setup after loading the view.
    }
    
    

    // MARK: - Methods

    func getMovieDetailData() {
        
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movie?id=\(id ?? "")") else {
            return
        }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                self.movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                
            } catch (let err) {
                print(err.localizedDescription)
                
                // failAlert
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "네트워크 오류", message: "데이터 수신에 실패하였습니다.", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "확인", style: .default) { _ in
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        
        dataTask.resume()
    }
    
    func getUserCommentsData() {
    
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/comments?movie_id=\(id ?? "")") else {
            return
        }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let apiResponse: UserCommentAPIResponse = try JSONDecoder().decode(UserCommentAPIResponse.self, from: data)
                self.userCommentArr = apiResponse.comments
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                    
                   
                }
                
            } catch (let err) {
                print(err.localizedDescription)
                
                // failAlert
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "네트워크 오류", message: "데이터 수신에 실패하였습니다.", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "확인", style: .default) { _ in
                        _ = self.navigationController?.popViewController(animated: true)
                    }
                    
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                
                
            }
        }
        
        dataTask.resume()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {
    

    // MARK: TableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return userCommentArr.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            guard let cell: MovieDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailTableViewCell", for: indexPath) as? MovieDetailTableViewCell else { return UITableViewCell() }
            
            if let movieDetail = movieDetail {
                cell.movieTitleLabel.text = movieDetail.title
                cell.movieDateLabel.text = movieDetail.date
                cell.movieGradeImageView.image = UIImage(named: movieDetail.gradeImageString)
                cell.movieGenreDurationLabel.text = movieDetail.genreDuration
                cell.movieRatingLabel.text = String(movieDetail.userRating)
                cell.movieReserveGradeRateLabel.text = movieDetail.reservationGradeRate
                cell.movieImageView.image = #imageLiteral(resourceName: "img_placeholder")
                cell.starRatingControl.rating = movieDetail.userRating
                cell.movieAudienceLabel.text = movieDetail.audienceFormatted

                
                cell.imageTapClosure = {
                    
                    if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailImageViewController") as? MovieDetailImageViewController {
                        presentedViewController.providesPresentationContextTransitionStyle = true
                        presentedViewController.definesPresentationContext = true
                        presentedViewController.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                        presentedViewController.movieImage = cell.movieImageView.image
                        
                        self.present(presentedViewController, animated: true, completion: nil)
                    }
                    
                }
                
                DispatchQueue.global().async {
                    guard let imageURL: URL = URL(string: movieDetail.image) else { return }
                    guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
                    DispatchQueue.main.async {
                        cell.movieImageView.image = UIImage(data: imageData)
                    }
                }
            }
            
            
            
            return cell
            
        case 1:
            guard let cell: MovieSynopsisTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieSynopsisTableViewCell", for: indexPath) as? MovieSynopsisTableViewCell else { return UITableViewCell() }
            
            cell.movieSynopsisLabel.text = movieDetail?.synopsis
            
            return cell
            
        case 2:
            guard let cell: MovieActorTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieActorTableViewCell", for: indexPath) as? MovieActorTableViewCell else { return UITableViewCell() }
            
            cell.movieDirectorLabel.text = movieDetail?.director
            cell.movieActorLabel.text = movieDetail?.actor
            
            return cell
            
        case 3:
            guard let cell: WriteCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WriteCommentTableViewCell", for: indexPath) as?
                WriteCommentTableViewCell else { return UITableViewCell() }
            
            return cell
            
        default:
            guard let cell: UserCommentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? UserCommentsTableViewCell else { return UITableViewCell() }
            
            let userComment = userCommentArr[indexPath.row]
            
            cell.userNameLabel.text = userComment.writer
            cell.userContentsLabel.text = userComment.contents
            cell.dateLabel.text = userComment.timestampFormatted
            DispatchQueue.main.async {
                cell.starRatingControl.rating = userComment.rating
                
            }
            
            return cell
        }
    }
    
    
    // MARK: TableViewDelegate

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 265
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 0))
        footerView.backgroundColor = UIColor.lightGray
        return footerView
    
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 3 || section == 4 {
            return 0
        }
        return 8
    }
   
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//
//
//        return headerView
//    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return
//    }
    
    
}
