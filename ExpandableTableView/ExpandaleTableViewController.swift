//
//  ExpandaleTableViewController.swift
//  ExpandableTableView
//
//  Created by Jubin Jacob on 22/01/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit

class ExpandaleTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let questionKey = "Question"
    let answerKey = "Answer"
    
    private lazy var tableView : UITableView = {
        let tbl = UITableView(frame: CGRectZero)
        tbl.separatorColor = UIColor.lightGrayColor()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.dataSource = self
        tbl.delegate = self
        tbl.registerClass(ExpandableTableViewCell.self, forCellReuseIdentifier: "CellID")
        return tbl
    } ()
    
    var dataSourceArray = [ItemModel]()
    
    var expandedIndexPaths : [NSIndexPath] = [NSIndexPath]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FAQ"
        self.addSubviews()
        self.fetchQuestions()
    }
    
    //MARK: fetch datasource json
    private func fetchQuestions() {
        guard let filePath = NSBundle.mainBundle().pathForResource("data", ofType: "json") else {
            print("File doesnot exist")
            return
        }
        guard let jsonData = NSData(contentsOfFile: filePath) else  {
            print("error parsing data from file")
            return
        }
        do {
            guard let jsonArray = try NSJSONSerialization.JSONObjectWithData(jsonData, options: NSJSONReadingOptions.AllowFragments) as? [[String:String]] else {
                print("json doesnot confirm to expected format")
                return
            }
            self.dataSourceArray = jsonArray.map({ (object) -> ItemModel in
                return ItemModel(question: object[self.questionKey]!,answer:object[self.answerKey]!)
            })
            self.tableView.reloadData()
        }
        catch {
            print("error\(error)")
        }
        
    }
    
    private func addSubviews() {
        self.view.addSubview(self.tableView)
        let views = ["view":self.tableView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    
    //MARK: table view datasource
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell : ExpandableTableViewCell = tableView.dequeueReusableCellWithIdentifier("CellID") as? ExpandableTableViewCell else {
            preconditionFailure("reusable cell not found")
        }
        let item = self.dataSourceArray[indexPath.row]
        cell.setCellContent(item, isExpanded: self.expandedIndexPaths.contains(indexPath))
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension
        } else {
            return self.dynamicCellHeight(indexPath)
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.dynamicCellHeight(indexPath)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.separatorInset = UIEdgeInsetsZero
        if #available(iOS 8.0, *) {
            tableView.layoutMargins = UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
        if #available(iOS 8.0, *) {
            cell.layoutMargins = UIEdgeInsetsZero
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK: table view delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if(self.expandedIndexPaths.contains(indexPath)) {
            let idx = self.expandedIndexPaths.indexOf(indexPath)
            self.expandedIndexPaths.removeAtIndex(idx!)
        } else {
            self.expandedIndexPaths.append(indexPath)
        }
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    
    //MARK: compute cell height
    
    private func dynamicCellHeight(indexPath:NSIndexPath)->CGFloat {
        struct StaticStruct {
            static var sizingCell : ExpandableTableViewCell?
            static var onceToken : dispatch_once_t = 0

        } // workaround to add static variables inside function in swift
        dispatch_once(&StaticStruct.onceToken) { () -> Void in
            StaticStruct.sizingCell = self.tableView.dequeueReusableCellWithIdentifier("CellID") as? ExpandableTableViewCell
            
        }
        let item = self.dataSourceArray[indexPath.row]
        StaticStruct.sizingCell?.setCellContent(item, isExpanded: self.expandedIndexPaths.contains(indexPath))
        StaticStruct.sizingCell?.setNeedsUpdateConstraints()
        StaticStruct.sizingCell?.updateConstraintsIfNeeded()
        StaticStruct.sizingCell?.setNeedsLayout()
        StaticStruct.sizingCell?.layoutIfNeeded()
        guard let height = StaticStruct.sizingCell?.cellContentHeight() else {
            return 0
        }
        return height
    }
    

    
}
