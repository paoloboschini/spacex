//
//  Launch.swift
//  SpaceX
//
//  Created by Paolo Boschini on 2019-04-30.
//  Copyright © 2019 Paolo Boschini. All rights reserved.
//

import UIKit

struct Launch: CustomStringConvertible {
    var missionName: String
    var videoLink: String? { // format video
        didSet {
            // source format can be https://www.youtube.com/watch?v=0a_00nJ_Y88
            // source format can be https://youtu.be/TXMGu2d8c8g
            if let videoLink = self.videoLink {
                self.videoLink = "https://www.youtube.com/embed/\(videoLink.suffix(11))"
            }
        }
    }

    var launchDate: String { // format date
        didSet {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.000Z"
            if let date = dateFormatter.date(from: self.launchDate) {
                let calendar = Calendar.current
                let year = calendar.component(.year, from: date)
                let day = calendar.component(.day, from: date)
                dateFormatter.dateFormat = "LLLL"
                let nameOfMonth = dateFormatter.string(from: date)
                self.launchDate = "\(day) \(nameOfMonth) \(year)"
            }
        }
    }

    init(missionName: String, launchDate: String, videoLink: String?) {
        self.missionName = missionName
        self.launchDate = launchDate
        self.videoLink = videoLink
        
        // Creative use of defer. This allows to call didSet during initialization to format fields
        // https://stackoverflow.com/questions/25230780/is-it-possible-to-allow-didset-to-be-called-during-initialization-in-swift
        defer {
            self.launchDate = launchDate
            self.videoLink = videoLink
        }
    }

    var description: String {
        return "\nmissionName: \(missionName), launchDate: \(launchDate)"
    }
}
