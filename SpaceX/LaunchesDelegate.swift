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
    var onLoadMoreTapped: (() -> ())

    init(onLoadMoreTapped: @escaping (() -> ())) {
        self.onLoadMoreTapped = onLoadMoreTapped
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.launches.count == 0 ? 0 : self.launches.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < self.launches.count {
            let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "LaunchCell")
            let launch = self.launches[indexPath.row]
            cell.textLabel?.text = launch.missionName
            cell.detailTextLabel?.text = launch.launchDate
            return cell
        } else {
            let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell")
            cell.textLabel?.text = "Load more launches"
            cell.textLabel?.alpha = 1
            return cell
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == self.launches.count {
            self.onLoadMoreTapped()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
