//
//  ViewController.swift
//  DarcoApp
//
//  Created by Parssa Kyanzadeh on 2021-05-10.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {

    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Open Darco", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .dark
        let webview = WKWebView()
        let buildFolder = Bundle.main.url(forResource: "build", withExtension: nil)!
        let htmlUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "build")!
        webview.loadFileURL(htmlUrl, allowingReadAccessTo: buildFolder)
        webview.navigationDelegate = self
        view = webview
        
//        view.addSubview(button)
//        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
//        button.frame = CGRect(x: 0, y: 0, width: 220, height: 50)
//        button.center = view.center
    }
    
    @objc private func didTapButton() {
//        guard let url = URL(string: "https://www.google.com") else {
//            return
//        }
//        let vc = DarcoViewController(url: url, title: "Darco")
        
//        let navVC = UINavigationController(rootViewController: vc)
//        present(navVC, animated: true)
    }
}

