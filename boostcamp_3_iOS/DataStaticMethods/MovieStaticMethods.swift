//
//  getMovieListDataFunction.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 14/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit

class MovieStaticMethods {
    
    static func getMovieData(completion: @escaping (_ isSucceed: Bool) -> Void) {
        
        let orderType = MovieListData.shared.sortRule.rawValue
        guard let url = URL(string: "http://connect-boxoffice.run.goorm.io/movies?order_type=\(orderType)") else { return }
        
        let session: URLSession = URLSession(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                completion(false)
                print(error.localizedDescription)
                return
            }
            
            guard let data = data else {
                completion(false)
                return
            }
            
            do {
                let apiResponse: MovieListAPIResopnse = try JSONDecoder().decode(MovieListAPIResopnse.self, from: data)
                MovieListData.shared.movieLists = apiResponse.movies
                completion(true)
                
            } catch {
                completion(false)
            }
        }
        dataTask.resume()
    }
    
}

