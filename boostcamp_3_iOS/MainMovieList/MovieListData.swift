//
//  MovieListData.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 10/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import Foundation

class MovieListData {
    
    static let shared: MovieListData = MovieListData()
    var movieListArr: [MovieList] = [MovieList]()
    
    var cache: NSCache<AnyObject, AnyObject>? = NSCache()
    
    var sortRule = orderType.reservationRate
        
    enum orderType: Int {
        case reservationRate = 0
        case curation
        case openingDate
    
        func name() -> String {
            switch self {
            case .reservationRate: return "예매율순"
            case .curation: return "큐레이션"
            case .openingDate: return "개봉일순"
            }
        }
    }
    
}
