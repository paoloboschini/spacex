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
    let launchService = LaunchService()

    override func viewDidLoad() {
        super.viewDidLoad()

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

    private func getData() {
        self.launchService.getLaunches(onSuccess: { launches in
            print(launches)
            self.launchesDelegate?.launches += launches
            self.updateUIOnCompletion()
        }) { error in
            self.updateUIOnCompletion(error: error)
        }
    }

    private func updateUIOnCompletion(error: String? = nil) {
        DispatchQueue.main.async(execute: {
//            self.loadingLaunches = false
            self.activityIndicatorView.stopAnimating()
            self.loadingLabel.layer.removeAllAnimations()
            self.tableView.reloadData()
            if let error = error {
                self.loadingLabel.text = error
                self.loadingLabel.alpha = 1
            }
        })
    }
}
