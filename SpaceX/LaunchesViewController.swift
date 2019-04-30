//
//  ViewController.swift
//  SpaceX
//
//  Created by Paolo Boschini on 2019-04-30.
//  Copyright © 2019 Paolo Boschini. All rights reserved.
//

import UIKit

class LaunchesViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    var launchesDelegate: LaunchesDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        let fakeLaunches = [
            Launch(missionName: "mission 1", launchDate: "now"),
            Launch(missionName: "mission 2", launchDate: "now"),
            Launch(missionName: "mission 3", launchDate: "now")
        ]
        self.launchesDelegate = LaunchesDelegate(launches: fakeLaunches)
        self.tableView.delegate = self.launchesDelegate
        self.tableView.dataSource = self.launchesDelegate
    }
}
