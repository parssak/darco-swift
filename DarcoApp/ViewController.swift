//
//  ViewController.swift
//  DarcoApp
//
//  Created by Parssa Kyanzadeh on 2021-05-10.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, WKScriptMessageHandler {

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
        
        // inject JS to capture console.log output and send to iOS
        let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webview.configuration.userContentController.addUserScript(script)
        webview.configuration.userContentController.add(self, name: "logHandler")
        
        let buildFolder = Bundle.main.url(forResource: "build", withExtension: nil)!
        let htmlUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "build")!
        webview.loadFileURL(htmlUrl, allowingReadAccessTo: buildFolder)
        webview.navigationDelegate = self
        view = webview
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == "logHandler" {
                print("LOG: \(message.body)")
            }
    }
    
    @objc private func didTapButton() {
//        guard let url = URL(string: "https://www.google.com") else {
//            return
//        }
//                let webview = WKWebView()
//        let buildFolder = Bundle.main.url(forResource: "build", withExtension: nil)!
//        let htmlUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "build")!
//        let vc = DarcoViewController(url: htmlUrl, title: "Darco")
//        let navVC = UINavigationController(rootViewController: vc)
//        present(navVC, animated: true)
    }
}

