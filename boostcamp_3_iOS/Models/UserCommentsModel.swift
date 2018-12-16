//
//  UserCommentsModel.swift
//  boostcamp_3_iOS
//
//  Created by 이호찬 on 16/12/2018.
//  Copyright © 2018 leehochan. All rights reserved.
//

import Foundation

// UserCommentsModel
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
