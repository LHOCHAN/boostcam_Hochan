//
//  getMovieListDataFunction.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 14/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import Foundation

class MovieTableCollectionMethods {
    
}

func getMovieListData(completion: @escaping () -> Void, catchError: @escaping (Error) -> Void) {
    
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
            completion()
            
//            DispatchQueue.main.async {
//
//                self.navigationTitle = MovieListData.shared.sortRule.name()
//                self.activityIndicator.stopAnimating()
//                self.tableView.reloadData()
//            }
        } catch (let err) {
            catchError(err)
//            print(err.localizedDescription)
//
//            // failAlert
//            DispatchQueue.main.async {
//
//                let alert = UIAlertController(title: "네트워크 오류", message: "데이터 수신에 실패하였습니다.", preferredStyle: .alert)
//
//                let ok = UIAlertAction(title: "확인", style: .default, handler: nil)
//
//                alert.addAction(ok)
//                self.present(alert, animated: true, completion: nil)
//            }
            
        }
    }
    
    dataTask.resume()
}
