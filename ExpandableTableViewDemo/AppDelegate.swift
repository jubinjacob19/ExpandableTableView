//
//  AppDelegate.swift
//  ExpandableTableViewDemo
//
//  Created by Jubin Jacob on 07/10/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit
import ExpandableTableView

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        loadTableView()
        return true
    }

    private func loadTableView() {
        let path = NSURL.fileURL(withPath: Bundle.main.path(forResource: "data", ofType: "json")!)
        let data = try! Data(contentsOf: path, options: .mappedIfSafe)
        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as! [[String:String]]
        let dataSource = json.map({return ItemModel(question: $0["Question"]!, answer: $0["Answer"]!)})
        self.window?.rootViewController = ExpandableTableViewController(faqs: dataSource)
    }
    


}

