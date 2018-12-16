//
//  MovieListModel.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 16/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import Foundation

// MovieListModel
struct MovieListAPIResopnse: Codable {
    let movies: [MovieList]
}

struct MovieList: Codable {
    
    let reservationGrade: Int
    let id: String
    let thumb: String
    let userRating: Double
    let reservationRate : Double
    let title: String
    let date: String
    let grade: Int
    
    var gradeImageString: String {
        if self.grade == 0 {
            return "ic_allages"
        } else {
            return "ic_\(self.grade)"
        }
    }
    
    // tableView labelText
    var tFullRate: String {
        return "평점 : \(self.userRating) " + "예매순위 : \(self.reservationGrade) " + "예매율 : \(self.reservationRate)"
    }
    
    // collectionView labelText
    var cFullRate: String {
        return "\(self.reservationGrade)위" + "(\(self.userRating)) / \(self.reservationRate)%"
    }
    
    enum CodingKeys: String, CodingKey {
        case id, thumb, title, date, grade
        case reservationGrade = "reservation_grade"
        case userRating = "user_rating"
        case reservationRate = "reservation_rate"
    }
    
}
