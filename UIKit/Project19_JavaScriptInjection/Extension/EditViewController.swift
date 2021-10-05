//
//  EditViewController.swift
//  Extension
//
//  Created by Tyler Edwards on 9/13/21.
//

import UIKit
import MobileCoreServices

class EditViewController: UIViewController {
    @IBOutlet var script: UITextView!
    
    var scriptURL: URL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = scriptURL.lastPathComponent.removingSuffix(".js")
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        
        loadScript()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveScript()
    }
    
    func loadScript() {
        DispatchQueue.main.async { [weak self] in
            if let url = self?.scriptURL {
                self?.script.text = try? String(contentsOf: url)
            }
        }
    }
    
    func saveScript() {
        try? script.text.write(to: scriptURL, atomically: false, encoding: .utf8)
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
