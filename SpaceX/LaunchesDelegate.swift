//
//  LaunchesDelegate.swift
//  SpaceX
//
//  Created by Paolo Boschini on 2019-04-30.
//  Copyright © 2019 Paolo Boschini. All rights reserved.
//

import UIKit

class LaunchesDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    var launches: [Launch] = []

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.launches.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "LaunchCell")
        let launch = self.launches[indexPath.row]
        cell.textLabel?.text = launch.missionName
        cell.detailTextLabel?.text = launch.launchDate
        return cell
    }
}
