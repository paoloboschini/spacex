//
//  LaunchService.swift
//  SpaceX
//
//  Created by Paolo Boschini on 2019-04-30.
//  Copyright © 2019 Paolo Boschini. All rights reserved.
//

import Foundation

class LaunchService {

    private var numberOfLoadedLaunches = 0
    private var launchesToLoadPerRequest = 20
    private var task: URLSessionDataTask?
    
    // https://gist.github.com/cmoulton/7ddc3cfabda1facb040a533f637e74b8
    func getLaunches(onSuccess: @escaping ([Launch]) -> (), onFail: @escaping (String) -> ()) {

        if self.task?.state == URLSessionTask.State.running {
            return
        }
        
        // Set up the URL request
        let endpoint = "https://api.spacexdata.com/v3/launches?limit=\(self.launchesToLoadPerRequest)&offset=\(self.numberOfLoadedLaunches)&order=desc"
        guard let url = URL(string: endpoint) else {
            onFail("Error: cannot create URL")
            return
        }
        
        // set up the session
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
        self.task = session.dataTask(with: urlRequest) { (data, response, error) in
            
            // check for any errors
            if let error = error {
                onFail(error.localizedDescription)
                return
            }
            
            // make sure we got data
            guard let responseData = data else {
                onFail("Error: did not receive data")
                return
            }
            
            // parse the result as JSON, since that's what the API provides
            do {
                guard let launches = try JSONSerialization.jsonObject(with: responseData, options: []) as? [Any] else {
                    onFail("error trying to convert data to JSON")
                    return
                }
                
                var launchList: [Launch] = []
                for launch in launches {
                    if  let launch = launch as? [String : Any],
                        let missionName = launch["mission_name"] as? String,
                        let launchDate = launch["launch_date_utc"] as? String {
                        launchList.append(Launch(missionName: missionName, launchDate: launchDate))
                    }
                }
                
                self.numberOfLoadedLaunches += launchList.count
                onSuccess(launchList)
                
            } catch  {
                onFail("error trying to convert data to JSON")
                return
            }
        }
        self.task?.resume()
    }
}
