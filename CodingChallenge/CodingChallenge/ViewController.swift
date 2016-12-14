//
//  ViewController.swift
//  CodingChallenge
//
//  Created by Reiner Pittinger on 14.12.16.
//  Copyright © 2016 clapp GmbH. All rights reserved.
//

import UIKit
import Alamofire
import JSONUtilities

class ViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    private var menuRoot: NavigationEntry?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadRequest(URLRequest(url: URL(string: "https://www.mytoys.de")!))
        webView.delegate = self
        loadMenuData()
    }

    @IBAction func unwindAndLoadWebpage(sender: UIStoryboardSegue) {
        guard let menuViewController = sender.source as? MenuViewController else { return }
        
        if let url = menuViewController.selectedUrl {
            let request = URLRequest(url: url)
            webView.loadRequest(request)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentMenu" {
            let naviVC = segue.destination as! UINavigationController
            let menuVC = naviVC.topViewController as! MenuViewController
            
            menuVC.navigationEntry = menuRoot
        }
    }
    
    private func loadMenuData() {
        Alamofire.request("https://mytoysiostestcase1.herokuapp.com/api/navigation", headers: ["x-api-key": "hz7JPdKK069Ui1TRxxd1k8BQcocSVDkj219DVzzD"]).validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { [weak self] response in
                switch response.result {
                case .success:
                    guard let data = response.data else {
                        assertionFailure("Could not load data")
                        return
                    }
                    
                    self?.parseJSONData(data: data)
                case .failure(let error):
                    print(error)
                }
        }
    }
    
    private func parseJSONData(data: Data) {
        do {
            let jsonDict = try JSONDictionary.from(jsonData: data)
            let rootEntries: [JSONDictionary] = try jsonDict.json(atKeyPath: "navigationEntries")
            let childs = NavigationEntry.childrenFromJsonDicts(dicts: rootEntries)
            
            menuRoot = NavigationEntry(label: "Navigation", children: childs)
        } catch {
            assertionFailure("COuld not parse data")
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        // print(webView.request)
    }

}

