//
//  LaunchDetailViewController.swift
//  SpaceX
//
//  Created by Paolo Boschini on 2019-05-02.
//  Copyright © 2019 Paolo Boschini. All rights reserved.
//

import UIKit
import WebKit

class LaunchDetailViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var webView: WKWebView!
    @IBOutlet var noVideoFoundLabel: UILabel!
    var launch: Launch?
    var details = ["Rocket Name", "Launch Success", "Flight Number"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.launch?.missionName
        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: (UIScreen.main.bounds.width / 4) * 3)
        self.tableView.tableHeaderView?.frame = frame
        self.tableView.tableFooterView = UIView()
        if let videoLink = self.launch?.videoLink, let url = URL(string: videoLink) {
            self.noVideoFoundLabel.isHidden = true
            self.webView.load(URLRequest(url: url))
        }
    }
}

extension LaunchDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.launch?.details == nil ? 3 : 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var c: UITableViewCell!
        switch indexPath.row {
        case 0:
            let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "InfoCell")
            cell.textLabel?.text = "Rocket Name"
            cell.detailTextLabel?.text = self.launch?.rocketName
            c = cell
        case 1:
            let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "InfoCell")
            cell.textLabel?.text = "Launch Success"
            cell.detailTextLabel?.text = (self.launch?.launchSuccess ?? false) ? "Yes" : "No"
            c = cell
        case 2:
            let cell: UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "InfoCell")
            cell.textLabel?.text = "Flight Number"
            if let flightNumber = self.launch?.flightNumber {
                cell.detailTextLabel?.text = "\(flightNumber)"
            } else {
                cell.detailTextLabel?.text = "Unavailable"
            }
            c = cell
        case 3:
            let cell: DetailCell! = tableView.dequeueReusableCell(withIdentifier: "DetailCell") as? DetailCell
            cell.detailLabel.text = self.launch?.details
            c = cell
        default:
            ()
        }
        return c
    }
}

class DetailCell: UITableViewCell {
    @IBOutlet var detailLabel: UILabel!
}
