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
    var launchDate: String { // format string
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

    init(missionName: String, launchDate: String) {
        self.missionName = missionName
        self.launchDate = launchDate
        defer {
            self.launchDate = launchDate
        }
    }

    var description: String {
        return "\nmissionName: \(missionName), launchDate: \(launchDate)"
    }
}
