//
//  AppDelegate.swift
//  ExpandableTableView
//
//  Created by Jubin Jacob on 22/01/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit
import CollapsibleTableView


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window?.rootViewController = UINavigationController(rootViewController: ExpandableTableViewController(faqs: fetchQuestions()))
        return true
    }

    private func fetchQuestions()->[ItemModel] {
        guard let filePath = NSBundle.mainBundle().pathForResource("data", ofType: "json") else {
            print("File doesnot exist")
            return [ItemModel]()
        }
        guard let jsonData = NSData(contentsOfFile: filePath) else  {
            print("error parsing data from file")
            return [ItemModel]()
        }
        do {
            guard let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? [[String:String]] else {
                print("json doesnot confirm to expected format")
                return [ItemModel]()
            }
            return jsonArray.map({ (object) -> ItemModel in
                return ItemModel(question: object["Question"]!,answer:object["Question"]!)
            })
            
        }
        catch {
            fatalError("could not parse json")
        }
        
    }

}

