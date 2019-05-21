//
//  DataSource.swift
//  SpaceX
//
//  Created by Paolo Boschini on 2019-05-21.
//  Copyright © 2019 Paolo Boschini. All rights reserved.
//

import Foundation

protocol DataSource {
    func getData(numberOfLoadedLaunches: Int, completionHandler: @escaping (Data?, Error?) -> Void)
}

let SPACE_X_API = "https://api.spacexdata.com/v3/launches?limit=%d&offset=%d&order=desc"
class NetworkDataSource: DataSource {
    
    private var launchesToLoadPerRequest = 20
    private var task: URLSessionDataTask?
    
    func getData(numberOfLoadedLaunches: Int, completionHandler: @escaping (Data?, Error?) -> Void) {
        if self.task?.state == URLSessionTask.State.running {
            return
        }
        
        // Set up the URL request
        let endpoint = String(format: SPACE_X_API, self.launchesToLoadPerRequest, numberOfLoadedLaunches)
        print("Calling \(endpoint)")
        guard let url = URL(string: endpoint) else {
            completionHandler(nil, NSError(domain: "Error: cannot create URL", code: 0, userInfo: nil))
            return
        }
        
        // set up the session
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        self.task = session.dataTask(with: urlRequest) { (data, response, error) in
            completionHandler(data, error)
        }
        self.task?.resume()
    }
}
