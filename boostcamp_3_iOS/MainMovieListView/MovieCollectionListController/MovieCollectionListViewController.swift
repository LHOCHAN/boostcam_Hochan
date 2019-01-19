//
//  MovieCollectionListViewController.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 09/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieCollectionListViewController: UIViewController {
    
    // MARK: - IBOutlets

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // MARK: - Properties
    
    let cellIdentifier = "MovieListCollectionViewCell"
    let itemLength = (UIScreen.main.bounds.width / 2) - 10
    
    var navigationTitle: String? {
        didSet {
            self.navigationItem.title = navigationTitle
        }
    }
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionViewLayout()
        
        // refreshControl
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshOptions(sender:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        // 데이터가 없을경우 받아옴
        if MovieListData.shared.movieLists.isEmpty {
            self.activityIndicator.startAnimating()
            getMovieListData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationTitle = MovieListData.shared.sortRule.name()
        collectionView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        MovieListData.shared.cache?.removeAllObjects()
    }
    
    // MARK: - Methods
    
    @objc func refreshOptions(sender: UIRefreshControl) {
        getMovieListData()
        sender.endRefreshing()
    }
    
    func collectionViewLayout() {
        
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let space = (view.bounds.width - itemLength * 2) / 3
            
            layout.sectionInset = .init(top: 10, left: space, bottom: 0, right: space)
            layout.itemSize = CGSize(width: itemLength, height: itemLength * 1.9)
            layout.minimumInteritemSpacing = space
            layout.minimumLineSpacing = 5
        }
    }
    
    func getMovieListData() {
        MovieStaticMethods.getMovieData { isSucced in
            if !isSucced {
                self.networkErrorAlert()
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                }
                return
            }
            DispatchQueue.main.async {
                self.navigationTitle = MovieListData.shared.sortRule.name()
                self.activityIndicator.stopAnimating()
                self.collectionView.reloadData()
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
        guard let cell: MovieListCollectionViewCell = sender as? MovieListCollectionViewCell else { return }
        guard let indexPath: IndexPath = collectionView.indexPath(for: cell) else { return }
        
        movieDetailViewController.id = MovieListData.shared.movieLists[indexPath.row].id
        movieDetailViewController.movieName = MovieListData.shared.movieLists[indexPath.row].title
        
        let backItem = UIBarButtonItem()
        backItem.title = "영화목록"
        navigationItem.backBarButtonItem = backItem
    }
    
}

// MARK: - CollectionView

extension MovieCollectionListViewController: UICollectionViewDataSource {
    
    // MARK: CollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MovieListData.shared.movieLists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MovieListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MovieListCollectionViewCell else { return UICollectionViewCell() }
        
        let movieList = MovieListData.shared.movieLists[indexPath.row]
        cell.configure(data: movieList)
        
        guard let imageURL: URL = URL(string: movieList.thumb) else { return UICollectionViewCell() }
        if (MovieListData.shared.cache?.object(forKey: imageURL.absoluteString as NSString) != nil) {
            
            cell.movieImageView.image = MovieListData.shared.cache?.object(forKey: imageURL.absoluteString as NSString)
            
        } else {
            
            DispatchQueue.global().async {
                guard let imageData: Data = try? Data(contentsOf: imageURL) else { return }
                DispatchQueue.main.async {
                    
                    if let index: IndexPath = collectionView.indexPath(for: cell) {
                        if index.row == indexPath.row {
                            
                            if let movieImage = UIImage(data: imageData) {
                                cell.movieImageView.image = movieImage
                                
                                MovieListData.shared.cache?.setObject(movieImage, forKey: imageURL.absoluteString as NSString)
                            }
                        }
                    }
                }
            }
        }
        return cell
    }
    
}
