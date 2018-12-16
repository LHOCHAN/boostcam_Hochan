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
    
    var id: String?
    var movieName: String?
    var movieDetail: MovieDetail?
    var movieImage: UIImage?
    var userComments: [UserComment] = [UserComment]()
    
    // MARK: - LifeCycles

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "MovieDetailTableViewCell", bundle: nil), forCellReuseIdentifier: "MovieDetailTableViewCell")
        tableView.tableFooterView?.backgroundColor = UIColor.gray

        self.navigationItem.title = movieName
        
        activityIndicator.startAnimating()
        
        getMovieDetailData()
        getUserCommentsData()
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
                self.dataError()
                return
            }
            
            guard let data = data else { return self.dataError() }
            
            do {
                self.movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
                
                DispatchQueue.global().async {
                    if let movieDetail = self.movieDetail {
                        guard let imageURL: URL = URL(string: movieDetail.image) else { return }
                        guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
                        self.movieImage = UIImage(data: imageData)
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            } catch (let err) {
                print(err.localizedDescription)
                
                self.dataError()
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
                self.dataError()
                return
            }
            
            guard let data = data else { return self.dataError() }
            
            do {
                let apiResponse: UserCommentAPIResponse = try JSONDecoder().decode(UserCommentAPIResponse.self, from: data)
                self.userComments = apiResponse.comments
                
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            } catch (let err) {
                print(err.localizedDescription)
                self.dataError()
            }
        }
        dataTask.resume()
    }
    
    func dataError() {
        networkErrorAlert() { _ in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

// MARK: - TableView

extension MovieDetailViewController: UITableViewDelegate, UITableViewDataSource {

    // MARK: TableViewDataSource

    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 4 {
            return userComments.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            // DetialCell
            guard let cell: MovieDetailTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieDetailTableViewCell", for: indexPath) as? MovieDetailTableViewCell else { return UITableViewCell() }
            
            if let movieDetail = self.movieDetail {
                cell.configure(data: movieDetail)
            }
            
            if let movieImage = movieImage {
                cell.movieImageView.image = movieImage

            }
            
            // 영화 이미지 탭할경우 모달
            cell.imageTapClosure = {
                if let presentedViewController = self.storyboard?.instantiateViewController(withIdentifier: "MovieDetailImageViewController") as? MovieDetailImageViewController {
                    presentedViewController.movieImage = cell.movieImageView.image
                    self.present(presentedViewController, animated: true, completion: nil)
                }
            }
            return cell
            
        case 1:
            // SynopsisCell
            guard let cell: MovieSynopsisTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieSynopsisTableViewCell", for: indexPath) as? MovieSynopsisTableViewCell else { return UITableViewCell() }
            
            if let movieDetail = self.movieDetail {
                cell.configure(data: movieDetail)
            }
            return cell
            
        case 2:
            // ActorCell
            guard let cell: MovieActorTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MovieActorTableViewCell", for: indexPath) as? MovieActorTableViewCell else { return UITableViewCell() }
            
            if let movieDetail = self.movieDetail {
                cell.configure(data: movieDetail)
            }
            return cell
            
        case 3:
            // WriteCommentCell
            guard let cell: WriteCommentTableViewCell = tableView.dequeueReusableCell(withIdentifier: "WriteCommentTableViewCell", for: indexPath) as? WriteCommentTableViewCell else { return UITableViewCell() }
            
            return cell
            
        default:
            // UserCommentsCell
            guard let cell: UserCommentsTableViewCell = tableView.dequeueReusableCell(withIdentifier: "UserCommentsTableViewCell", for: indexPath) as? UserCommentsTableViewCell else { return UITableViewCell() }
            
            cell.configure(data: userComments[indexPath.row])
            
            return cell
        }
    }
    
    // MARK: TableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if tableView.bounds.size.width * 0.7 < 265 {
                return 265
            }
            return tableView.bounds.size.width * 0.7
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
            return CGFloat.leastNonzeroMagnitude
        }
        return 8
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}
