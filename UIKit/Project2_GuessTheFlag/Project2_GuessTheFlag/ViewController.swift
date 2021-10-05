//
//  ViewController.swift
//  Project2_GuessTheFlag
//
//  Created by Tyler Edwards on 8/22/21.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {
    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var count = 0
    var correctAnswer = 0
    
    static let maxCount = 10
    
    var highscore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manageNotifications()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(scorePopup))
        
        let defaults = UserDefaults.standard
        highscore = defaults.integer(forKey: "highscore")
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        button1.transform = .identity
        button2.transform = .identity
        button3.transform = .identity
        
        title = "\(countries[correctAnswer].uppercased()) - Score: \(score)"
    }
    
    func retry(action: UIAlertAction!) {
        score = 0
        count = 0
        
        askQuestion()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 10, options: []) {
            sender.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }
        
        // Answer and scoring
        var title: String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
            //score -= 1 NOTE: Changed score to total correct answers
        }
        
        count += 1
        
        if count == ViewController.maxCount {
            // Final Message
            var highscoreMsg = ""
            if score > highscore {
                highscoreMsg = "That's a new highscore!"
                save()
            }
            
            let ac = UIAlertController(title: title, message: "Your final score is \(score) / \(count). \(highscoreMsg)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play Again", style: .default, handler: retry))
            present(ac, animated: true)
        } else {
            // Answer
            let ac = UIAlertController(title: title, message: "Your score is \(score) / \(count)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }
    
    @objc func scorePopup() {
        let ac = UIAlertController(title: "Your score is \(score) / \(count)", message: "\(ViewController.maxCount - count) to go!", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Close", style: .default, handler: nil))
        present(ac, animated: true)
    }
    
    func save() {
        let defaults = UserDefaults.standard
        defaults.set(highscore, forKey: "highscore")
    }
    
}

//NOTE: Challenge from Project 21
extension ViewController: UNUserNotificationCenterDelegate {
    func manageNotifications() {
        requestAuthorization() //NOTE: calls scheduleDailies if granted
    }
    
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .badge, .sound]) { [weak self] granted, error in
            if granted {
                center.delegate = self ?? nil
                self?.scheduleDailies()
            }
        }
    }
    
    func scheduleDailies() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
        center.removeAllDeliveredNotifications()
        
        let content = UNMutableNotificationContent()
        content.title = "Remember to This Game"
        content.body = "It was project 2 in HWS"
        content.categoryIdentifier = "reminder"
        content.userInfo = [:]
        content.sound = UNNotificationSound.default
        
        for i in 1...7 {
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: .days(i), repeats: false)
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            center.add(request)
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Launched by notification")
        scheduleDailies()
        completionHandler()
    }
    
}

extension TimeInterval {
    static func days(_ days: Int) -> TimeInterval {
        //return TimeInterval(86_400 * days)
        return TimeInterval(10 * days)
    }
}
