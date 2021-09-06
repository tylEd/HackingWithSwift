//
//  ViewController.swift
//  Project1_StormViewer
//
//  Created by Tyler Edwards on 8/14/21.
//

import UIKit

class ViewController: UICollectionViewController {
    var pictures = [String]()
    var viewCount = [String:Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
        
        let defaults = UserDefaults.standard
        if let savedViewCount = defaults.object(forKey: "viewCount") as? Data {
            let decoder = JSONDecoder()
            
            do {
                viewCount = try decoder.decode([String:Int].self, from: savedViewCount)
            } catch {
                print("Failed to load viewCount.")
            }
        }
        
        print(viewCount)
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        //NOTE: Challenge 2
        pictures.sort()
        
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Picture", for: indexPath) as? PictureCell else {
            fatalError("Unable to dequeue PictureCell")
        }
        
        let picture = pictures[indexPath.item]
        
        let path = Bundle.main.resourceURL!
        let url = path.appendingPathComponent(picture)
        cell.imageView.image = UIImage(contentsOfFile: url.path)
        
        if viewCount.keys.contains(picture) {
            let count = viewCount[picture] ?? 1
            cell.viewCountLabel.text = "  \(count) View\(count > 1 ? "" : "s")  "
        } else {
            cell.viewCountLabel.text = ""
        }
        cell.viewCountLabel.layer.masksToBounds = true
        cell.viewCountLabel.layer.cornerRadius = 5

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let picture = pictures[indexPath.item]
            vc.selectedImage = picture
            
            //NOTE: Challenge 3
            vc.imageIndex = indexPath.row
            vc.imageCount = pictures.count
            
            // Increment viewCount for this image here
            if viewCount.keys.contains(picture) {
                viewCount[picture]! += 1
            } else {
                viewCount[picture] = 1
            }
            save()
            collectionView.reloadItems(at: [indexPath])

            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let saveData = try? encoder.encode(viewCount) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "viewCount")
        } else {
            print("Failed to save viewCount.")
        }
    }

}

//MARK: Original UITableViewController Version
class ViewController_TableViewController: UITableViewController {
    var pictures = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Storm Viewer"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        performSelector(inBackground: #selector(loadPictures), with: nil)
    }
    
    @objc func loadPictures() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        //NOTE: Challenge 2
        pictures.sort()
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = pictures[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedImage = pictures[indexPath.row]
            
            //NOTE: Challenge 3
            vc.imageIndex = indexPath.row
            vc.imageCount = pictures.count

            navigationController?.pushViewController(vc, animated: true)
        }
    }

}
