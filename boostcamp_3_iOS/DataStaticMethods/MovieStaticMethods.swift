//
//  getMovieListDataFunction.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 14/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import UIKit


enum RequestType {
    case movieListRequest
    case movieDetailInfoRequest
    case movieCommentRequest
}


class MovieStaticMethods {
    
    static let shared = MovieStaticMethods()
    private let baseURL: String = "http://connect-boxoffice.run.goorm.io/"
    typealias completion<T: Decodable> = (Bool, T?, Error?) -> Void
    
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
    
    func movieInfoRequest<T: Decodable>(requestType: RequestType ,parameterValue: String, completion: @escaping completion<T>) {
        
        guard let url = URL(string: makeURL(url: baseURL , requeType: requestType, paraValue: parameterValue)) else {
            return
        }
        let session: URLSession = URLSession.init(configuration: .default)
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil, error)
                return
            }
            
            guard let data = data else {
                completion(false, nil, nil)
                return
            }
            
            do {
                let apiResponse = try JSONDecoder().decode(T.self, from: data)
                completion(true, apiResponse, nil)
            } catch {
                completion(false, nil, error)
            }
        }
        dataTask.resume()
    }
    
    private func makeURL(url: String, requeType: RequestType, paraValue: String) -> String{
        var baseURL = url
        
        switch requeType {
        case .movieListRequest:
            baseURL += "movies?order_type=\(paraValue)"
        case .movieDetailInfoRequest:
            baseURL += "movie?id=\(paraValue)"
        case .movieCommentRequest:
            baseURL += "comments?movie_id=\(paraValue)"
        }
        
        return baseURL
    }
    
}

