//
//  WikiViewController.swift
//  Project16_CapitalCities
//
//  Created by Tyler Edwards on 9/10/21.
//

import UIKit
import WebKit

class WikiViewController: UIViewController {
    var city: String!
    
    var webView: WKWebView!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let cityName = city.replacingOccurrences(of: " ", with: "").lowercased()
        let urlString = "https://en.wikipedia.org/wiki/\(cityName)"
        if let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }

}
