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
        
        self.activityIndicator.startAnimating()
        getMovieListData()
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
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        MovieStaticMethods.getMovieData { isSucced in
            if !isSucced {
                self.networkErrorAlert()
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                self.navigationTitle = MovieListData.shared.sortRule.name()
                self.activityIndicator.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - IBActions
    
    @IBAction func actionChangeSortingRule(_ sender: UIBarButtonItem) {
        sortActionSheet { title in
            self.navigationTitle = title
            self.activityIndicator.startAnimating()
            self.getMovieListData()
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let movieDetailViewController: MovieDetailViewController = segue.destination as? MovieDetailViewController else { return }
        guard let cell: MovieListTableViewCell = sender as? MovieListTableViewCell else { return }
        guard let indexPath: IndexPath = tableView.indexPath(for: cell) else { return }
        
        movieDetailViewController.id = MovieListData.shared.movieLists[indexPath.row].id
        movieDetailViewController.movieName = MovieListData.shared.movieLists[indexPath.row].title
        
        let backItem = UIBarButtonItem()
        backItem.title = "영화목록"
        navigationItem.backBarButtonItem = backItem
    }
    
}

// MARK: - TableView

extension MovieTableListViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: TableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieListData.shared.movieLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MovieListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MovieListTableViewCell else { return UITableViewCell() }
        
        let movieList = MovieListData.shared.movieLists[indexPath.row]
        cell.configure(data: movieList)
        
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

