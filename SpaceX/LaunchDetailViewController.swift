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

    @IBOutlet var webView: WKWebView!
    var launch: Launch?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.launch?.missionName
        if let videoLink = self.launch?.videoLink, let url = URL(string: videoLink) {
            self.webView.load(URLRequest(url: url))
        }
    }
}
