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
    @IBOutlet var loadingLabel: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    private var isInStack = false
    var launchesDelegate: LaunchesDelegate?
    var refreshControl = UIRefreshControl()
    var launchService: LaunchService?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let dataSource = NetworkDataSource()
        self.launchService = LaunchService(dataSource: dataSource)

        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(refreshControl)

        let onLoadMoreTapped = {
            if let cell = self.tableView.visibleCells.last {
                cell.textLabel?.text = "Loading..."
                UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse], animations: {
                    cell.textLabel?.alpha = 0
                }, completion: nil)
            }
            self.getData()
        }

        self.launchesDelegate = LaunchesDelegate(onLoadMoreTapped: onLoadMoreTapped)
        self.tableView.delegate = self.launchesDelegate
        self.tableView.dataSource = self.launchesDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if self.isInStack { return }
        self.isInStack = true

        // Set up UI
        self.loadingLabel.text = "Loading launches..."
        self.tableView.tableFooterView = UIView()
        self.activityIndicatorView.startAnimating()
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.loadingLabel.alpha = 0
        }, completion: nil)

        // Get data
        self.getData()
    }
    
    // MARK: - Navigation
     
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let launchDetailViewController = segue.destination as? LaunchDetailViewController {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                launchDetailViewController.launch = self.launchesDelegate?.launches[indexPath.row]
            }
        }
    }

    // MARK: - Actions

    @objc func refresh() {
        self.launchesDelegate?.launches = []
        self.launchService?.numberOfLoadedLaunches = 0
        self.getData()
    }

    // MARK: - Privates

    private func getData() {
        self.launchService?.getLaunches(completionHandler: { launches, error in
            if let error = error {
                self.updateUIOnCompletion(error: error)
            } else {
                print(launches)
                self.launchesDelegate?.launches += launches
                self.updateUIOnCompletion()
            }
        })
    }

    private func updateUIOnCompletion(error: String? = nil) {
        DispatchQueue.main.async(execute: {
            self.activityIndicatorView.stopAnimating()
            self.loadingLabel.layer.removeAllAnimations()
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            if let error = error {
                self.loadingLabel.text = error
                self.loadingLabel.alpha = 1
            }
        })
    }
}
