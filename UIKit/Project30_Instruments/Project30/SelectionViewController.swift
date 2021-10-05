//
//  SelectionViewController.swift
//  Project30
//
//  Created by TwoStraws on 20/08/2016.
//  Copyright (c) 2016 TwoStraws. All rights reserved.
//

import UIKit

class SelectionViewController: UITableViewController {
    var items = [String]() // this is the array that will store the filenames to load
    //DELETE: var viewControllers = [UIViewController]() // create a cache of the detail view controllers for faster loading
    var dirty = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Reactionist"
        
        tableView.rowHeight = 90
        tableView.separatorStyle = .none
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        // load all the JPEGs into our array
        let fm = FileManager.default
        
        if let tempItems = try? fm.contentsOfDirectory(atPath: Bundle.main.resourcePath!) {
            for item in tempItems {
                if item.range(of: "Large") != nil {
                    items.append(item)
                }
            }
        }
        
        cacheItemImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if dirty {
            // we've been marked as needing a counter reload, so reload the whole table
            tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return items.count * 10
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let currentImage = items[indexPath.row % items.count]
        
        // each image stores how often it's been tapped
        let defaults = UserDefaults.standard
        cell.textLabel?.text = "\(defaults.integer(forKey: currentImage))"
        
        // find the image for this cell, and load its thumbnail
        guard let image = itemImageCache[currentImage] else {
            return cell
        }
        
        cell.imageView?.image = image
        
        // give the images a nice shadow to make them look a bit more dramatic
        cell.imageView?.layer.shadowColor = UIColor.black.cgColor
        cell.imageView?.layer.shadowOpacity = 1
        cell.imageView?.layer.shadowRadius = 10
        cell.imageView?.layer.shadowOffset = CGSize.zero
        cell.imageView?.layer.shadowPath = UIBezierPath(ovalIn: CGRect(origin: .zero, size: image.size)).cgPath
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ImageViewController()
        vc.image = items[indexPath.row % items.count]
        vc.owner = self
        
        // mark us as not needing a counter reload when we return
        dirty = false
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: Cache Images
    
    var itemImageCache = [String:UIImage]()
    
    func cacheItemImages() {
        for currentImage in items {
            let docsPath = getDocumentsDirectory().appendingPathComponent(currentImage)
            if let image = UIImage(contentsOfFile: docsPath.absoluteString) {
                itemImageCache[currentImage] = image
                continue
            }
            
            let imageRootName = currentImage.replacingOccurrences(of: "Large", with: "Thumb")
            guard let path = Bundle.main.path(forResource: imageRootName, ofType: nil),
                  let original = UIImage(contentsOfFile: path)
            else {
                continue
            }
            
            let renderRect = CGRect(origin: .zero, size: CGSize(width: 90, height: 90))
            //let renderer = UIGraphicsImageRenderer(size: original.size)
            let renderer = UIGraphicsImageRenderer(size: renderRect.size)
            let rounded = renderer.image { ctx in
                //ctx.cgContext.addEllipse(in: CGRect(origin: CGPoint.zero, size: original.size))
                ctx.cgContext.addEllipse(in: renderRect)
                ctx.cgContext.clip()
                
                //original.draw(at: CGPoint.zero)
                original.draw(in: renderRect)
            }
            
            itemImageCache[currentImage] = rounded
            
            // Save the cached image to documents
            if let data = rounded.jpegData(compressionQuality: 0.8) {
                try? data.write(to: docsPath)
            }
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

}
