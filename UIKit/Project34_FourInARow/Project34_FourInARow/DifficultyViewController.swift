//
//  DifficultyViewController.swift
//  Project34_FourInARow
//
//  Created by Tyler Edwards on 9/28/21.
//

import UIKit

class DifficultyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func easyTapped(_ sender: Any) {
        launchGameWith(difficulty: .easyAI)
    }
    
    @IBAction func normalTapped(_ sender: Any) {
        launchGameWith(difficulty: .normalAI)
    }
    
    @IBAction func hardTapped(_ sender: Any) {
        launchGameWith(difficulty: .hardAI)
    }
    
    func launchGameWith(difficulty: Oponent) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "GameVC") as? ViewController {
            vc.oponent = difficulty
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
