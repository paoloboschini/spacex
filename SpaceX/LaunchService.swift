//
//  LaunchService.swift
//  SpaceX
//
//  Created by Paolo Boschini on 2019-04-30.
//  Copyright © 2019 Paolo Boschini. All rights reserved.
//

import Foundation

class LaunchService {

    private let dataSource: DataSource
    var numberOfLoadedLaunches = 0

    init(dataSource: DataSource) {
        self.dataSource = dataSource
    }
    
    func getLaunches(completionHandler: @escaping ([Launch], String?) -> Void) {
        self.dataSource.getData(numberOfLoadedLaunches: numberOfLoadedLaunches) { data, error in

            // check for any errors
            if let error = error {
                completionHandler([], error.localizedDescription)
                return
            }

            // make sure we got data
            guard let data = data else {
                completionHandler([], "Error: did not receive data")
                return
            }
            
            guard let launches = try? JSONDecoder().decode([Launch].self, from: data) else {
                print("Error: Couldn't decode data into Launches")
                return
            }

            self.numberOfLoadedLaunches += launches.count
            completionHandler(launches, nil)
        }
    }
}
