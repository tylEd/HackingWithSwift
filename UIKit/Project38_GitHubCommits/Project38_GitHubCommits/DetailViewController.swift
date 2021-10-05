//
//  DetailViewController.swift
//  Project38_GitHubCommits
//
//  Created by Tyler Edwards on 10/1/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var detailLabel: UILabel!
    
    var detailItem: Commit?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let detail = self.detailItem {
            detailLabel.text = detail.message
            // navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Commit 1/\(detail.author.commits.count)", style: .plain, target: self, action: #selector(showAuthorCommits))
        }
    }
    
}
