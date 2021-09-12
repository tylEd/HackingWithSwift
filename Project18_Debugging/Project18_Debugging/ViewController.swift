//
//  ViewController.swift
//  Project18_Debugging
//
//  Created by Tyler Edwards on 9/12/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("I'm inside the viewDidLoad() method.")
        print("Some message ", terminator: "")
        print(1, 2, 3, 4, 5, separator: "-")
        
        assert(1 == 1, "Math failure!")
        //assert(1 == 2, "Math failure!")
        //NOTE: only runs in debug mode, not in release
        //assert(myReallySlowMethod() == true, "Slow method returned false")
        
        for i in 1...100 {
            print("Got number \(i).")
        }
    }

}

