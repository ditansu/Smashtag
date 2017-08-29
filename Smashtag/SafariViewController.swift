//
//  SafariViewController.swift
//  Smashtag
//
//  Created by di on 21.08.17.
//  Copyright © 2017 ditansu. All rights reserved.
//

import UIKit
import WebKit


class SafariViewController: UIViewController, WKUIDelegate, WKNavigationDelegate {

    
    
    
    var URL : URL?
    private var webView : WKWebView!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var goBackButton: UIBarButtonItem!
    @IBOutlet var goForwardButton: UIBarButtonItem!
    
    @IBOutlet var progressView: UIProgressView!
    
    
    @IBAction func goBack(_ sender: UIBarButtonItem) {
        webView.goBack()
    }
    
    @IBAction func goForward(_ sender: UIBarButtonItem) {
        webView.goForward()
    }
    
    override func loadView() {
        super.loadView()
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame:  containerView.bounds, configuration: webConfig)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.sizeToFit()
        webView.allowsBackForwardNavigationGestures = true
        containerView.addSubview(webView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let myURL = URL {
            let myRequest = URLRequest(url: myURL)
            webView.load(myRequest)
        }
       
        //navigation & progress
        let webViewKeyPathsToObserve = ["loading", "estimatedProgress"]
        //webView.lodin
        for keyPath in webViewKeyPathsToObserve {
            webView.addObserver(self, forKeyPath: keyPath, options: .new, context: nil)
        }
    
        updateNavigationButtons()

    }
    

    
    deinit {
      
        let webViewKeyPathsToObserve = ["loading", "estimatedProgress"]
        for keyPath in webViewKeyPathsToObserve {
            webView.removeObserver(self, forKeyPath: keyPath)
        }

    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    
    func updateNavigationButtons(){
        goBackButton?.isEnabled = webView?.canGoBack ?? false
        goForwardButton?.isEnabled = webView?.canGoForward ?? false

    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        guard  let keyPath = keyPath else { return }
        
        switch keyPath {
        case "loading":
            updateNavigationButtons()
        case "estimatedProgress" :
            progressView.isHidden = webView.estimatedProgress == 1
            progressView.progress = Float(webView.estimatedProgress)
        default:
            break
        }
        
        
    }
    
// MARK: - JUST FOR ANY CASE
// Alternative JavaScipt alert\promt\input panels 
// If you do not implement this method, a JavaScript text alert\prompt\input panel is displayed anyway.
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alert = UIAlertController (
            title: "Сообщение",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "ОК",
            style: .default
        ) {_ in completionHandler() }
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
    func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let alert = UIAlertController (
            title: "Подтверждение",
            message: message,
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(
            title: "ОК",
            style: .default
        ) {_ in completionHandler(true) }
        
        
        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .default
        ) {_ in completionHandler(false) }
        
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Void) {
        
        let alert = UIAlertController (
            title: "Ввод",
            message: prompt,
            preferredStyle: .alert
        )
        
        alert.addTextField{ (textField) in textField.text = defaultText  }
        
        let okAction = UIAlertAction(
            title: "ОК",
            style: .default
        ) {_ in
           let textField = alert.textFields![0] as UITextField
           completionHandler(textField.text) }
        
        
        let cancelAction = UIAlertAction(
            title: "Отмена",
            style: .default
        ) {_ in completionHandler(nil) }

        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)

        
    }
    
    
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        handleError(error: error)
    }
    
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        handleError(error: error)
    }
    
    
    func handleError(error: Error) {
    
    print("webView erorr:\(error.localizedDescription)")
    }
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
