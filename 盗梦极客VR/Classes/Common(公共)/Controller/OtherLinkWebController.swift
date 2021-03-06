//
//  OtherLinkWebController.swift
//  盗梦极客VR
//
//  Created by wl on 5/1/16.
//  Copyright © 2016 wl. All rights reserved.
//  一个内嵌浏览器，加载一些非论坛的链接

import UIKit
import WebKit
import MBProgressHUD

class OtherLinkWebController: UIViewController {
        /// 需要加载的请求
    var URLStr: String!
    var webView: WKWebView!
    
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var request: NSURLRequest {
        return NSURLRequest(URL: NSURL(string: URLStr)!, cachePolicy: .UseProtocolCachePolicy, timeoutInterval: 15)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        
        titleLabel.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    @IBAction func backButtonClik() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    deinit {
        dPrint("deinit---")
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

extension OtherLinkWebController {
    /**
     初始化、设置webview
     */
    func setupWebView() {
        
        let configuretion = WKWebViewConfiguration()
        
        let webView = WKWebView(frame: CGRectZero, configuration: configuretion)
        view.addSubview(webView)
        self.webView = webView
        
        webView.snp_makeConstraints { (make) in
            make.top.equalTo(self.progressView.snp_bottom)
            make.bottom.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        // 监听加载进度
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.navigationDelegate = self
        webView.loadRequest(request)
    }

}

// MARK: - WKNavigationDelegate
extension OtherLinkWebController: WKNavigationDelegate {

    func webView(webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        dPrint("正在加载...")
        progressView.progress = 0
        progressView.hidden = false
    }
    
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        dPrint("加载成功...")
        progressView.hidden = true
        webView.hidden = false
        titleLabel.hidden = false
        titleLabel.text = webView.title
    }
    
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        dPrint("加载失败")
        MBProgressHUD.showError("网络异常，请稍后尝试！")
        progressView.hidden = true
        progressView.progress = 0
    }
    
}
