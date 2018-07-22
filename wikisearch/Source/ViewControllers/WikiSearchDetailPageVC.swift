//
//  WikiSearchDetailPageVC.swift
//  wikisearch
//
//  Created by Kumar m p, Hemanth - Hemanth on 7/22/18.
//  Copyright © 2018 Kumar m p, Hemanth - Hemanth. All rights reserved.
//

import UIKit

class WikiSearchDetailPageVC: UIViewController {

    @IBOutlet weak var webpage: UIWebView!
    var url: URL?
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = url {
            let request = URLRequest(url: url)
            webpage.loadRequest(request)
        }
       
        // Do any additional setup after loading the view.
    }
}
