//
//  SessionViewController.swift
//  CountIT
//
//  Created by Claudio S. Di Mauro on 30/05/18.
//  Copyright © 2018 Claudio S. Di Mauro. All rights reserved.
//

import UIKit

class SessionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //NavigationBar backButton and LeftItem color
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //NavigationBar hiding
        self.navigationController?.isNavigationBarHidden = true
    }
}
