//
//  ViewController.swift
//  WebBrowser
//
//  Created by Vanessa Tavares Tavernari on 01/02/2022.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var refresh: UIBarButtonItem!
  
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.navigationDelegate = self
        
        self.view.addSubview(webView)
        
        let safeArea = self.view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            webView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: safeArea.leftAnchor),
            webView.rightAnchor.constraint(equalTo: safeArea.rightAnchor),
        ])
        
        self.loadWebView(website: "https://www.hackingwithswift.com")
        webView.allowsBackForwardNavigationGestures = true
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        self.barButtonItem()
    }
    
    func barButtonItem() {

        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: #selector(self.reloadWebView))
        self.progressView = UIProgressView(progressViewStyle: .default)
        self.progressView.sizeToFit()
        self.progressView.tintColor = .purple

        let progressButton = UIBarButtonItem(customView: progressView)

        self.refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(self.reloadWebView))
        self.refresh.tintColor = .purple

        toolbarItems = [progressButton, spacer]

        navigationController?.isToolbarHidden = false

        navigationItem.title = ""
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector((openTapped)))
        navigationItem.rightBarButtonItem?.tintColor = .purple
    }
    
    func loadWebView(website: String) {
        
        let url = URL(string: website)!
        webView.load(URLRequest(url: url))
    }
    
    func removeRefreshButton() {
        
        self.toolbarItems?.removeLast()
        self.progressView.isHidden = false
    }
    
    func addRefreshButton() {
        
        self.toolbarItems?.append(self.refresh)
        self.progressView.isHidden = true
    }
    
    @objc func reloadWebView() {
        
        self.removeRefreshButton()
        self.webView.reload()
    }
    
    @objc func openTapped() {
        
        let alertController = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "apple.com", style: .default, handler: openPage))
        alertController.addAction(UIAlertAction(title: "hackingwithswift.com", style: .default, handler: openPage))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alertController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(alertController, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        
        guard let actionTitle = action.title else { return }
        self.removeRefreshButton()
        self.loadWebView(website: "https://" + actionTitle)
        let title = actionTitle
        self.navigationController?.title = ("\(title)")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        title = webView.title
        self.addRefreshButton()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
}
