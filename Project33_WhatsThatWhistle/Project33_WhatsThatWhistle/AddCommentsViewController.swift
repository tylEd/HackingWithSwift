//
//  AddCommentsViewController.swift
//  Project33_WhatsThatWhistle
//
//  Created by Tyler Edwards on 9/26/21.
//

import UIKit

class AddCommentsViewController: UIViewController, UITextViewDelegate {
    var genre: String!
    
    var comments: UITextView!
    let placeholder = "If you have any additional comments that might help identify your tune, enter them here."
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        comments = UITextView()
        comments.translatesAutoresizingMaskIntoConstraints = false
        comments.delegate = self
        comments.font = UIFont.preferredFont(forTextStyle: .body)
        comments.text = placeholder
        view.addSubview(comments)
        
        NSLayoutConstraint.activate([
            comments.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            comments.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            comments.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            comments.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Comments"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .plain, target: self, action: #selector(submitTapped))
    }
    
    @objc func submitTapped() {
        let vc = SubmitViewController()
        vc.genre = genre
        
        if comments.text == placeholder {
            vc.comments = ""
        } else {
            vc.comments = comments.text
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == placeholder {
            textView.text = ""
        }
    }

}
