//
//  MovieTableListViewController.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 09/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieTableListViewController: UIViewController {

    // MARK: - IBOutlets

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    let cellIdentifier = "MovieListTableViewCell"
    
    var navigationTitle: String? {
        didSet {
            self.navigationItem.title = navigationTitle
        }
    }
    
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        
        // 데이터가 없을경우 받아옴
        if MovieListData.shared.movieListArr.isEmpty {
            activityIndicator.startAnimating()
            boostcamp_3_iOS.getMovieListData(completion: {
                DispatchQueue.main.async {
                    
                    self.navigationTitle = MovieListData.shared.sortRule.name()
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            }) { err in
                print(err.localizedDescription)
                
                // failAlert
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "네트워크 오류", message: "데이터 수신에 실패하였습니다.", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationTitle = MovieListData.shared.sortRule.name()
        tableView.reloadData()
        
    }
    
    
    // MARK: - Methods

    @objc func refreshOptions(sender: UIRefreshControl) {
        getMovieListData()
        sender.endRefreshing()
    }
    
    func getMovieListData() {
        
        activityIndicator.startAnimating()
        
        MovieListData.shared.cache?.removeAllObjects()
        let orderType = MovieListData.shared.sortRule.rawValue
        
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)") else {
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
                let apiResponse: MovieListAPIResopnse = try JSONDecoder().decode(MovieListAPIResopnse.self, from: data)
                MovieListData.shared.movieListArr = apiResponse.movies

                DispatchQueue.main.async {
                    
                    self.navigationTitle = MovieListData.shared.sortRule.name()
                    self.activityIndicator.stopAnimating()
                    self.tableView.reloadData()
                }
            } catch (let err) {
                print(err.localizedDescription)
                
                // failAlert
                DispatchQueue.main.async {
                    
                    let alert = UIAlertController(title: "네트워크 오류", message: "데이터 수신에 실패하였습니다.", preferredStyle: .alert)
                    
                    let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
                    
                    alert.addAction(ok)
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
        
        dataTask.resume()
    }
    
    
    // MARK: - IBActions
    
    @IBAction func actionChangeSortingRule(_ sender: UIBarButtonItem) {
        
        let actionSheet = UIAlertController(title: "정렬방식 선택", message: "영화를 어떤 순서로 정렬할까요?", preferredStyle: .actionSheet)
        
        let reservationRate = UIAlertAction(title: "예매율", style: .default) { _ in
            MovieListData.shared.sortRule = MovieListData.orderType.reservationRate
            self.navigationTitle = MovieListData.shared.sortRule.name()
            
            self.getMovieListData()
        }
        
        let userRating = UIAlertAction(title: "큐레이션", style: .default) { _ in
            MovieListData.shared.sortRule = MovieListData.orderType.curation
            self.navigationTitle = MovieListData.shared.sortRule.name()

            self.getMovieListData()
        }
        
        let data = UIAlertAction(title: "개봉일", style: .default) { _ in
            MovieListData.shared.sortRule = MovieListData.orderType.openingDate
            self.navigationTitle = MovieListData.shared.sortRule.name()

            self.getMovieListData()
        }
        
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        actionSheet.addAction(reservationRate)
        actionSheet.addAction(userRating)
        actionSheet.addAction(data)
        actionSheet.addAction(cancel)
        
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieDetailViewController: MovieDetailViewController = segue.destination as? MovieDetailViewController else {
            return
        }
        
        guard let cell: MovieListTableViewCell = sender as? MovieListTableViewCell else {
            return
        }
        
        guard let indexPath: IndexPath = tableView.indexPath(for: cell) else {
            return
        }
        
        movieDetailViewController.id = MovieListData.shared.movieListArr[indexPath.row].id
        movieDetailViewController.movieName = MovieListData.shared.movieListArr[indexPath.row].title
        
    }

}


// MARK: - TableView


extension MovieTableListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: TableViewDataSource

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieListData.shared.movieListArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieListTableViewCell else { return UITableViewCell() }
        
        let movieList = MovieListData.shared.movieListArr[indexPath.row]
        
        cell.movieTitleLabel.text = movieList.title
        cell.movieFullRateLabel.text = movieList.tFullRate
        cell.movieDateLabel.text = "개봉일 : " + movieList.date
        cell.movieGradeImageView.image = UIImage(named: movieList.gradeImageString)
        cell.movieImageView.image = #imageLiteral(resourceName: "img_placeholder")
                
        
        if (MovieListData.shared.cache?.object(forKey: (indexPath as NSIndexPath).row as AnyObject) != nil) {
            
            cell.movieImageView.image = MovieListData.shared.cache?.object(forKey: (indexPath as NSIndexPath).row as AnyObject) as? UIImage
        } else {
            
            DispatchQueue.global().async {
                guard let imageURL: URL = URL(string: movieList.thumb) else { return }
                guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
                DispatchQueue.main.async {
                    
                    if let index: IndexPath = tableView.indexPath(for: cell) {
                        if index.row == indexPath.row {
                            
                            if let movieImage = UIImage(data: imageData) {
                                cell.movieImageView.image = movieImage
                                
                                MovieListData.shared.cache?.setObject(movieImage, forKey: (indexPath as NSIndexPath).row as AnyObject)
                            }
                        }
                    }
                    
                }
            }
        }
        return cell
    }
    
    // MARK: TableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

