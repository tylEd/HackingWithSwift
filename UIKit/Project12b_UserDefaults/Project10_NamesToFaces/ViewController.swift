//
//  ViewController.swift
//  Project10_NamesToFaces
//
//  Created by Tyler Edwards on 9/4/21.
//

import UIKit
import LocalAuthentication

class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var people = [Person]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
        let defaults = UserDefaults.standard
        if let savedPeople = defaults.object(forKey: "people") as? Data {
            let decoder = JSONDecoder()
            
            do {
                people = try decoder.decode([Person].self, from: savedPeople)
            } catch {
                print("Failed to load people.")
            }
        }
        
        loadProject28Challenge()
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            fatalError("Unable to dequeue PersonCell.")
        }
        
        let person = people[indexPath.item]
        
        cell.name.text = person.name
        
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        cell.imageView.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        
        cell.layer.cornerRadius = 7
        
        //NOTE: Not sure how to fix the cell sizing issue.
        //      Changing "Estimate Size" to "None" on the CollectionView seems to have fixed it.
        //cell.frame.size = cell.contentView.frame.size
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let ac = UIAlertController(title: "What to do?", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
            self?.people.remove(at: indexPath.item)
            self?.save()
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            self?.renamePerson(indexPath: indexPath)
        })
        present(ac, animated: true)
    }
    
    func renamePerson(indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Ok", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            self?.save()
            self?.collectionView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func addNewPerson() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        }
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
        }
        
        let person = Person(name: "Unknown", image: imageName)
        people.append(person)
        save()
        collectionView.reloadData()
        
        dismiss(animated: true)
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func save() {
        let encoder = JSONEncoder()
        
        if let saveData = try? encoder.encode(people) {
            let defaults = UserDefaults.standard
            defaults.set(saveData, forKey: "people")
        } else {
            print("Failed to save people.")
        }
    }
    
}

//MARK: Project 28 Challenge

extension ViewController {
    
    func loadProject28Challenge() {
        lock()

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(lock), name: UIApplication.willResignActiveNotification, object: nil)
    }

    @objc func authenticateTapped() {
        let ctx = LAContext()
        var error: NSError?
        
        if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlock()
                    } else {
                        //NOTE: FaceID has it's own alert.
                    }
                }
            }
        } else {
            let ac = UIAlertController(title: "Biometry Unavailable", message: "Your device doesn't allow biometric authentication.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            present(ac, animated: true)
        }
    }

    @objc func unlock() {
        collectionView.isHidden = false
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc func lock() {
        collectionView.isHidden = true
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Authenticate", style: .plain, target: self, action: #selector(authenticateTapped))
    }

}