//
//  ActionViewController.swift
//  Extension
//
//  Created by Tyler Edwards on 9/13/21.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var pageTitle = ""
    var pageURL = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(selectSample))
        
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            if let itemProvider = inputItem.attachments?.first {
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] dict, error in
                    guard let itemDict = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDict[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    self?.loadScript()

                    DispatchQueue.main.async { //NOTE: Nested closure doesn't need [weak self]
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }
    
    func loadScript() {
        let defaults = UserDefaults.standard
        if let url = URL(string: pageURL),
           let host = url.host,
           let savedScript = defaults.string(forKey: host)
        {
            DispatchQueue.main.async { [weak self] in
                self?.script.text = savedScript
            }
        }
    }
    
    func saveScript() {
        if let url = URL(string: pageURL),
           let host = url.host
        {
            let defaults = UserDefaults.standard
            defaults.set(script.text, forKey: host)
        }
    }

    @IBAction func done() {
        saveScript()
        
        let item = NSExtensionItem()
        let argument: NSDictionary = ["customJavaScript": script.text!]
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: argument]
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        item.attachments = [customJavaScript]
        extensionContext?.completeRequest(returningItems: [item])
    }
    
    @objc func selectSample() {
        let ac = UIAlertController(title: "Samples", message: "Select a sample script.", preferredStyle: .actionSheet)
        
        let setScript = { [weak self] (action: UIAlertAction) -> Void in
            self?.script.text = action.title
        }
        ac.addAction(UIAlertAction(title: "alert(document.title);", style: .default, handler: setScript))
        ac.addAction(UIAlertAction(title: "alert(document.URL);", style: .default, handler: setScript))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            script.contentInset = .zero
        } else {
            script.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        script.scrollIndicatorInsets = script.contentInset
        
        let selectedRange = script.selectedRange
        script.scrollRangeToVisible(selectedRange)
    }

}
