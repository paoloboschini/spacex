//
//  Launch.swift
//  SpaceX
//
//  Created by Paolo Boschini on 2019-04-30.
//  Copyright © 2019 Paolo Boschini. All rights reserved.
//

import UIKit

struct Launch: Decodable {
    var missionName: String?
    var launchDate: String?
    var rocket: Rocket?
    var launchSuccess: Bool?
    var flightNumber: Int?
    var details: String?
    var links: Links?
    enum CodingKeys : String, CodingKey {
        case missionName = "mission_name"
        case launchDate = "launch_date_utc"
        case rocket
        case launchSuccess = "launch_success"
        case flightNumber = "flight_number"
        case details
        case links
    }

    var formattedLaunchDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
        if let date = dateFormatter.date(from: self.launchDate ?? "") {
            let calendar = Calendar.current
            let year = calendar.component(.year, from: date)
            let day = calendar.component(.day, from: date)
            dateFormatter.dateFormat = "LLLL"
            let nameOfMonth = dateFormatter.string(from: date)
            return "\(day) \(nameOfMonth) \(year)"
        }
        return nil
    }

    var formattedVideo: String? {
        // source format can be https://www.youtube.com/watch?v=0a_00nJ_Y88
        // source format can be https://youtu.be/TXMGu2d8c8g
        if let videoLink = self.links?.videoLink {
            return "https://www.youtube.com/embed/\(videoLink.suffix(11))"
        }
        return nil
    }
}

struct Links: Decodable {
    var videoLink: String?
    enum CodingKeys : String, CodingKey {
        case videoLink = "video_link"
    }
}

struct Rocket: Decodable {
    var rocketName: String?
    enum CodingKeys : String, CodingKey {
        case rocketName = "rocket_name"
    }
}
