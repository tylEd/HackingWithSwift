//
//  StartViewController.swift
//  Project34_FourInARow
//
//  Created by Tyler Edwards on 9/28/21.
//

import UIKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func pvpTapped(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GameVC") as? ViewController {
            vc.oponent = .player
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
