//
//  Model.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 09/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import Foundation

// MARK: - MovieListModel

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


// MARK: - MovieDetailModel

struct MovieDetail: Codable {
    
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let image: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    let numberFormatter: Formatter = {
        let formatter: NumberFormatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
    
    var audienceFormatted: String {
        return numberFormatter.string(for: audience) ?? "0"
    }
    
    var gradeImageString: String {
        if self.grade == 0 {
            return "ic_allages"
        } else {
            return "ic_\(self.grade)"
        }
    }
    
    var genreDuration: String {
        return "\(self.genre)/\(self.duration)분"
    }
    
    var reservationGradeRate: String {
        return "\(self.reservationGrade)위 " + "\(self.reservationRate)%"
    }
    
    
    enum CodingKeys: String, CodingKey {
        case audience, actor, duration, director, synopsis, genre, grade, image, title, date, id
        case reservationGrade = "reservation_grade"
        case userRating = "user_rating"
        case reservationRate = "reservation_rate"
    }
}


// MARK: - UserCommentsModel

struct UserCommentAPIResponse: Codable {
    let comments: [UserComment]
}

struct UserComment: Codable {
    
    let rating: Double
    let timestamp: Double
    let writer: String
    let movieId: String
    let contents: String
    
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "GMT")
        formatter.locale = NSLocale.current
        formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
        return formatter
    }()
    
    var timestampFormatted: String {
        let date = Date(timeIntervalSince1970: timestamp)
        return dateFormatter.string(from: date)
    }
    
    enum CodingKeys: String, CodingKey {
        case rating, timestamp, writer, contents
        case movieId = "movie_id"
    }
}


