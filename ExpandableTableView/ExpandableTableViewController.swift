//
//  ExpandableTableViewController.swift
//  CollapsibleTableView
//
//  Created by Jubin Jacob on 10/08/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit

public class ExpandableTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private lazy var tableView : UITableView = {
        let tbl = UITableView(frame: CGRectZero)
        tbl.separatorColor = UIColor.lightGrayColor()
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.dataSource = self
        tbl.delegate = self
        tbl.registerClass(ExpandableTableViewCell.self, forCellReuseIdentifier: "CellID")
        return tbl
    } ()
    
    public var dataSourceArray = [ItemModel]()
    
    var expandedIndexPaths : [NSIndexPath] = [NSIndexPath]()
    
    public convenience init(faqs: [ItemModel]) {
        self.init(nibName: nil, bundle: nil)
        self.dataSourceArray = faqs
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FAQ"
        self.addSubviews()
    }
    
    override public func viewDidAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    
    private func addSubviews() {
        self.view.addSubview(self.tableView)
        let views = ["view":self.tableView]
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    
    //MARK: table view datasource
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell : ExpandableTableViewCell = tableView.dequeueReusableCellWithIdentifier("CellID") as? ExpandableTableViewCell else {
            preconditionFailure("reusable cell not found")
        }
        let item = self.dataSourceArray[indexPath.row]
        cell.setCellContent(item, isExpanded: self.expandedIndexPaths.contains(indexPath))
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        return cell
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension
        } else {
            return self.dynamicCellHeight(indexPath)
        }
    }
    
    public func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.dynamicCellHeight(indexPath)
    }
    
    public func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
       
    }
    
    //MARK: table view delegate
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
