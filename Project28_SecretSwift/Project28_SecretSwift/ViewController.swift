//
//  ViewController.swift
//  Project28_SecretSwift
//
//  Created by Tyler Edwards on 9/21/21.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {
    @IBOutlet var secret: UITextView!
    
    var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Nothing to see here"
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(saveSecretMsg))

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(saveSecretMsg), name: UIApplication.willResignActiveNotification, object: nil)
        // keyboard
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @IBAction func authenticateTapped(_ sender: Any) {
        let ctx = LAContext()
        var error: NSError?
        
        if !hasPassword() {
            createPassword()
            return
        }

        if ctx.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Identify yourself!"
            
            ctx.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authError in
                DispatchQueue.main.async {
                    if success {
                        self?.unlockSecretMsg()
                    } else {
                        //NOTE: FaceID has it's own alert.
                        //let ac = UIAlertController(title: "Authentication Failed", message: "Something went wrong, try again", preferredStyle: .alert)
                        //ac.addAction(UIAlertAction(title: "Ok", style: .default))
                        //self?.present(ac, animated: true)
                    }
                }
            }
        } else {
            checkPassword()
            //let ac = UIAlertController(title: "Biometry Unavailable", message: "Your device doesn't allow biometric authentication.", preferredStyle: .alert)
            //ac.addAction(UIAlertAction(title: "Ok", style: .default))
            //present(ac, animated: true)
        }
    }
    
    //MARK: Password
    
    func hasPassword() -> Bool {
        //NOTE: I'm not sure of the security of this. Research before using for real.
        return KeychainWrapper.standard.string(forKey: "Password") != nil
    }
    
    func createPassword() {
        let ac = UIAlertController(title: "Create Password", message: "Be sure to make it secure", preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let password = ac.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            if password != "" {
                KeychainWrapper.standard.set(password, forKey: "Password")
                self?.performSelector(onMainThread: #selector(self?.unlockSecretMsg), with: nil, waitUntilDone: true)
            } else {
                self?.showPasswordErrorAlert(msg: "Password must not be empty. Please try again.")
            }
        })
        present(ac, animated: true)
    }
    
    func checkPassword() {
        let ac = UIAlertController(title: "Enter Password", message: "Biometry is unavailable", preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Enter", style: .default) { [weak self] _ in
            guard let password = ac.textFields?[0].text else { return }
            
            if KeychainWrapper.standard.string(forKey: "Password") == password {
                self?.performSelector(onMainThread: #selector(self?.unlockSecretMsg), with: nil, waitUntilDone: true)
            } else {
                self?.showPasswordErrorAlert(msg: "Incorrect password. Please try again.")
            }
        })
        
        present(ac, animated: true)
    }
    
    func showPasswordErrorAlert(msg: String) {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Password Error", message: msg, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Ok", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
    //MARK: Secret
    
    @objc func unlockSecretMsg() {
        secret.isHidden = false
        title = "Secret stuff!"

        secret.text = KeychainWrapper.standard.string(forKey: "SecretMessage") ?? ""
        navigationItem.rightBarButtonItem = doneButton
    }
    
    @objc func saveSecretMsg() {
        guard secret.isHidden == false else { return }
        
        KeychainWrapper.standard.set(secret.text, forKey: "SecretMessage")
        secret.resignFirstResponder()
        secret.isHidden = true
        title = "Nothing to see here"
        navigationItem.rightBarButtonItem = nil
    }
    
    //MARK: Keyboard
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        
        if notification.name == UIResponder.keyboardWillHideNotification {
            secret.contentInset = .zero
        } else {
            secret.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }
        
        secret.scrollIndicatorInsets = secret.contentInset
        
        let selectedRange = secret.selectedRange
        secret.scrollRangeToVisible(selectedRange)
    }
    
}

