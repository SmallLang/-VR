//
//  NewsDetailController.swift
//  盗梦极客VR
//
//  Created by wl on 4/26/16.
//  Copyright © 2016 wl. All rights reserved.
//

import UIKit
import MBProgressHUD

class NewsDetailController: UIViewController {
    
    /// 这里不使用WKWebView是因为Loadhtml方法加载出来的，样式会很奇怪
    @IBOutlet weak var webView: UIWebView!
    
    var newsModel: NewsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        loadNewsDetail()
        webView.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    @IBAction func backButtonClik() {
        navigationController?.popViewControllerAnimated(true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func shareButtonClik() {
        
        ShareTool.setAllShareConfig(newsModel)
        UMSocialSnsService.presentSnsIconSheetView(self, appKey: nil, shareText: nil, shareImage: ShareTool.shareImage, shareToSnsNames: ShareTool.shareArray, delegate: nil)
    }
    
}

extension NewsDetailController: UIWebViewDelegate {
    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        MBProgressHUD.showError("网络异常，请稍后尝试！")
    }
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let urlStr = request.URL!.absoluteString
        if urlStr == "about:blank" || urlStr.hasPrefix("http://player.youku.com/") || urlStr.hasPrefix("http://v.qq.com/iframe/player.html") {
            return true
        }
        // TODO: 以后用内部跳转
//        UIApplication.sharedApplication().openURL(request.URL!)
        jumpToOtherLinker(request.URLString)
        return false
    }
    
    func jumpToOtherLinker(urlStr: String) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("OtherLinkWebController") as! OtherLinkWebController
        vc.URLStr = urlStr
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewsDetailController {
    func loadNewsDetail() {
        
        let css = NSBundle.mainBundle().URLForResource("Details.css", withExtension: nil)!
        
        var html = "<html>"
        
        html += "<head>"
        html += "<link rel=\"stylesheet\" href="
        html += "\"\(css)\""
        html += ">"
        html += "</head>"
        html += getBody()
        html += "</html>"
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
    func getBody() -> String {
        var body = "<body>"
        
        body += "<div class=\"title\">"
        body += newsModel.title
        body += "</div>"
        
        body += "<div class=\"time\">"
        body += newsModel.date
        body += "</div>"
        
        body += newsModel.content
        
        body += "</body>"
        
        return body
    }
    
}
