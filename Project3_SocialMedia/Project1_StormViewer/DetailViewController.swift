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
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

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
    
    @objc func shareTapped() {
        guard let image = imageView.image else {
            print("No image found")
            return
        }

        let overlayImage = renderOverlay(for: image)
        
        guard let jpgData = overlayImage.jpegData(compressionQuality: 0.8) else {
            print("Failed to get jpeg data from image")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [ jpgData, selectedImage ?? "" ],
                                          applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    func renderOverlay(for image: UIImage) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        
        let image = renderer.image { ctx in
            image.draw(at: .zero)
            
            // Text
            NSAttributedString(string: "From Storm Viewer",
                               attributes: [
                                .font: UIFont.systemFont(ofSize: 36),
                               ]
            ).draw(with: CGRect(x: 16, y: 16, width: image.size.width, height: image.size.height), options: .usesLineFragmentOrigin, context: nil)
        }
        
        return image
    }

}
