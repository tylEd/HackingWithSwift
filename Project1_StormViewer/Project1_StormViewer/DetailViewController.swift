//
//  DetailViewController.swift
//  Project1_StormViewer
//
//  Created by Tyler Edwards on 8/14/21.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    
    var selectedImage: String?
    
    //NOTE: Challenge 3
    var imageIndex: Int?
    var imageCount: Int? //TODO: Chould this be a protocol delegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //NOTE: Challenge 3
        if let index = imageIndex {
            if let count = imageCount {
                title = "Picture \(index + 1) of \(count)"
            } else {
                title = "Picture \(index + 1)"
            }
        } else {
            title = selectedImage
        }
        
        navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageView.image =  UIImage(named: imageToLoad)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
