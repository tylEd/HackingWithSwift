//
//  SiteTableTableViewController.swift
//  Project4_EasyBrowser
//
//  Created by Tyler Edwards on 8/30/21.
//

import UIKit

class SiteTableTableViewController: UITableViewController {
    let websites = [
        "apple.com",
        "hackingwithswift.com",
        "youtube.com"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Select a Site"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WebsiteName", for: indexPath)

        cell.textLabel?.text = websites[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Browser") as? ViewController {
            vc.startingSite = websites[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
