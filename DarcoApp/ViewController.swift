//
//  ViewController.swift
//  DarcoApp
//
//  Created by Parssa Kyanzadeh on 2021-05-10.
//

import UIKit
import WebKit

let sendPDFBlob = "sendPDFBlob"
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
//        view.insetsLayoutMarginsFromSafeArea = false
        overrideUserInterfaceStyle = .dark
        
        let config = WKWebViewConfiguration()
        config.userContentController.add(self, name: sendPDFBlob)
        let rect = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        let webview = WKWebView(frame: rect, configuration: config)
        
        // inject JS to capture console.log output and send to iOS
        let source = "function captureLog(msg) { window.webkit.messageHandlers.logHandler.postMessage(msg); } window.console.log = captureLog;"
        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: false)
        webview.configuration.userContentController.addUserScript(script)
        webview.configuration.userContentController.add(self, name: "logHandler")
        
        let buildFolder = Bundle.main.url(forResource: "build", withExtension: nil)!
        let htmlUrl = Bundle.main.url(forResource: "index", withExtension: "html", subdirectory: "build")!
        webview.loadFileURL(htmlUrl, allowingReadAccessTo: buildFolder)
        webview.navigationDelegate = self
//        webview.insetsLayoutMarginsFromSafeArea = false
        view = webview
//        view.insetsLayoutMarginsFromSafeArea = false
    }
    
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("triggered")
        if message.name == "logHandler" {
            print("LOG: \(message.body)")
        }
        else if message.name == sendPDFBlob {
            guard let dict = message.body as? [String: AnyObject],
                  let base64String = dict["data"] as? String,
                  let fileName = dict["name"] as? String else {
                    return
            }
            print(">> got", fileName)
//            saveBase64StringToPDF(base64String: base64String, fileName: fileName)
            let convertedData = Data(base64Encoded: base64String)
            let activityVC = UIActivityViewController(activityItems: [convertedData], applicationActivities: nil)
            present(activityVC, animated: true, completion: nil)
            if let popOver = activityVC.popoverPresentationController {
              popOver.sourceView = self.view
              popOver.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 10)
            }
        }
    }
    
    func saveBase64StringToPDF(base64String: String, fileName: String) {
        var cacheURL = (FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)).last
        let convertedData = Data(base64Encoded: base64String)
        print("converted data")
//        guard
//            var documentsURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last,
//            let convertedData = Data(base64Encoded: base64String)
//            else {
//            print("err occured")
//            //handle error when getting documents URL
//            return
//        }
        print("no error occured!")
        //name your file however you prefer
        cacheURL!.appendPathComponent("Parssa_Kyanzadeh_Resume.pdf")
        if (cacheURL == nil) {
            print("No cache url")
            return;
        }
        do {
            try convertedData?.write(to: cacheURL!)
        } catch {
            //handle write error here
            print("write error :(")
        }

        //if you want to get a quick output of where your
        //file was saved from the simulator on your machine
        //just print the documentsURL and go there in Finder
        print("Printed!", cacheURL!)
        let activityVC = UIActivityViewController(activityItems: [convertedData], applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
        if let popOver = activityVC.popoverPresentationController {
          popOver.sourceView = self.view
          popOver.sourceRect = CGRect(x: 0, y: 0, width: 1, height: 10)
        }
    }
//
//    /**
//     * Copy a resource from the bundle to the temp directory.
//
//     * Returns either NSURL of location in temp directory, or nil upon failure.
//     *
//     * Example: copyBundleResourceToTemporaryDirectory("kittens", "jpg")
//     */
//    public func copyBundleResourceToTemporaryDirectory(resourceName: String, fileExtension: String) -> NSURL?
//    {
//        // Get the file path in the bundle
//        if let bundleURL = Bundle.main.url(forResource: resourceName, withExtension: fileExtension) {
//
//            let tempDirectoryURL = NSURL.fileURL(withPath: NSTemporaryDirectory(), isDirectory: true)
//
//            // Create a destination URL.
//            let targetURL = tempDirectoryURL.appendingPathComponent("\(resourceName).\(fileExtension)")
//
//            // Copy the file.
//            do {
//                try FileManager.default.copyItem(at: bundleURL, to: targetURL)
//                return targetURL as NSURL
//            } catch let error {
//                NSLog("Unable to copy file: \(error)")
//            }
//        }
//
//        return nil
//    }
}

