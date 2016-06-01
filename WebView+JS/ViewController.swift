//
//  ViewController.swift
//  WebView+JS
//
//  Created by Emiko Clark on 5/27/16.
//  Copyright © 2016 Emiko Clark. All rights reserved.
//

import UIKit
import WebKit

class ViewController:  UIViewController, WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {

//    @IBOutlet var webView: WkWebView!
    
    @IBOutlet var containerView : UIView! = nil
    @IBOutlet weak var alertButton: UIButton!
    var webView: WKWebView?

    
    // MARK: - View Controller methods
    
    override func loadView() {
        super.loadView()
        
        let contentController = WKUserContentController()
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        contentController.addScriptMessageHandler(self, name: "callbackHandler")
        
        let frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 400)
        
        self.webView =  WKWebView(frame: frame, configuration: config)
        
        self.view.addSubview(self.webView!)
        
        self.webView?.UIDelegate = self;
    }
    
     func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: (() -> Void)) {
        
        //print js message to console
        print(message)
        completionHandler()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        //local html file
        let localURL = NSBundle.mainBundle().pathForResource("myWebPage", ofType: "html")
    
        
        let url = NSURL(string: localURL!)

        let HtmlString: NSString?
        
        do {
            //read html file int HTMLString -> from directory as a string
            HtmlString = try NSString(contentsOfFile: localURL!, encoding: NSUTF8StringEncoding)
            
            //displays HTMLString in WKWebView
            self.webView!.loadHTMLString(HtmlString as! String, baseURL: url )
            
        } catch {
            HtmlString = nil
        }
    }
    
    
    //MARK: JS-Swift Communication Methods
    
    @IBAction func alertButtonTapped(sender: AnyObject) {
        
        let jsMessage : String = "The IOS Button triggered a JavaScript Alert!"

        let alert = UIAlertController(title: "Alert", message: jsMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func userContentController(userContentController: WKUserContentController,didReceiveScriptMessage message: WKScriptMessage) {
        if(message.name == "callbackHandler") {
            print("JavaScript is sending a message \(message.body)")
        }
    }
    
    // MARK: - Utility methods

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


}


