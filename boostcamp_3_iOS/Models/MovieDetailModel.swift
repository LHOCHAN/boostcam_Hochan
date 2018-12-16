//
//  Model.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 09/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import Foundation

// MovieDetailModel
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



