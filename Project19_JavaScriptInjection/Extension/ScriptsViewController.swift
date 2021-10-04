//
//  ScriptsViewController.swift
//  Extension
//
//  Created by Tyler Edwards on 10/3/21.
//

import UIKit
import MobileCoreServices


class ScriptsViewController: UITableViewController {
    var scriptFiles = [URL]()
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(newScript))
        
        // Get site details
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] dict, error in
                    guard let itemDict = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDict[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    self?.loadScriptFiles()
                    
                    DispatchQueue.main.async { //NOTE: Nested closure doesn't need [weak self]
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    @objc func close() {
        extensionContext?.completeRequest(returningItems: [])
    }
    
    @objc func newScript() {
        let ac = UIAlertController(title: "Name", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.addAction(UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            if let name = ac.textFields?[0].text,
               let url = self?.getSiteDir().appendingPathComponent(name.withSuffix(".js"))
            {
                if let files = self?.scriptFiles,
                   files.contains(url)
                {
                    self?.showErrorAlert(message: "That file already exists")
                    return
                }
                
                let initalText = "alert(document.title);"
                try? initalText.write(to: url, atomically: false, encoding: .utf8)
                
                self?.scriptFiles.insert(url, at: 0)
                
                DispatchQueue.main.async {
                    self?.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                }
            }
        })
        
        present(ac, animated: true)
    }

    func loadScriptFiles() {
        if let contents = try? FileManager.default.contentsOfDirectory(at: getSiteDir(), includingPropertiesForKeys: nil) {
            let scripts = contents.filter { $0.pathExtension == "js" }
            for scriptName in scripts {
                self.scriptFiles.append(scriptName)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func showErrorAlert(message: String?) {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            self?.present(ac, animated: true)
        }
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scriptFiles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let script = scriptFiles[indexPath.row]
        cell.textLabel?.text = script.lastPathComponent.removingSuffix(".js")
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let scriptFile = scriptFiles[indexPath.row]
            try? FileManager.default.removeItem(at: scriptFile)
            
            scriptFiles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "EditVC") as? EditViewController {
            let script = scriptFiles[indexPath.row]
            vc.scriptURL = script
            
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getSiteDir() -> URL {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let host = URL(string: pageURL)!.host! //NOTE: Shouldn't be called until after pageURL is valid
        let siteDir = docs.appendingPathComponent(host)
        
        if !FileManager.default.fileExists(atPath: siteDir.absoluteString) {
            // Create the directory
            try? FileManager.default.createDirectory(at: siteDir, withIntermediateDirectories: true, attributes: nil)
        }
        
        return siteDir
    }
    
}
