//
//  ExpandableTableViewController.swift
//  CollapsibleTableView
//
//  Created by Jubin Jacob on 10/08/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit

open class ExpandableTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
 
    
    fileprivate lazy var sizingCell : ExpandableTableViewCell = {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier:"CellID") as? ExpandableTableViewCell else{
            preconditionFailure("reusable cell not found")
        }
        return cell
    } ()
    
    fileprivate lazy var tableView : UITableView = {
        let tbl = UITableView(frame: CGRect.zero)
        tbl.separatorColor = UIColor.lightGray
        tbl.translatesAutoresizingMaskIntoConstraints = false
        tbl.dataSource = self
        tbl.delegate = self
        tbl.register(ExpandableTableViewCell.self, forCellReuseIdentifier: "CellID")
        return tbl
    } ()
    
    open var dataSourceArray = [ItemModel]()
    
    var expandedIndexPaths : [IndexPath] = [IndexPath]()
    
    public convenience init(faqs: [ItemModel]) {
        self.init(nibName: nil, bundle: nil)
        self.dataSourceArray = faqs
    }
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.title = "FAQ"
        self.addSubviews()
    }
    
    fileprivate func addSubviews() {
        self.view.addSubview(self.tableView)
        let views = ["view":self.tableView]
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views))
    }
    
    
    //MARK: table view datasource
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell : ExpandableTableViewCell = tableView.dequeueReusableCell(withIdentifier: "CellID") as? ExpandableTableViewCell else {
            preconditionFailure("reusable cell not found")
        }
        let item = self.dataSourceArray[(indexPath as NSIndexPath).row]
        cell.setCellContent(item, isExpanded: self.expandedIndexPaths.contains(indexPath))
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSourceArray.count
    }
    
    open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1) {
            return UITableViewAutomaticDimension
        } else {
            return self.dynamicCellHeight(indexPath)
        }
    }
    
    open func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.dynamicCellHeight(indexPath)
    }
    
    open func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.layoutMargins = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
       
    }
    
    //MARK: table view delegate
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(self.expandedIndexPaths.contains(indexPath)) {
            let idx = self.expandedIndexPaths.index(of: indexPath)
            self.expandedIndexPaths.remove(at: idx!)
        } else {
            self.expandedIndexPaths.append(indexPath)
        }
        self.tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.automatic)
    }
    
    
    //MARK: compute cell height
    
    fileprivate func dynamicCellHeight(_ indexPath:IndexPath)->CGFloat {
        
        let item = self.dataSourceArray[(indexPath as NSIndexPath).row]
        sizingCell.setCellContent(item, isExpanded: self.expandedIndexPaths.contains(indexPath))
        sizingCell.setNeedsUpdateConstraints()
        sizingCell.updateConstraintsIfNeeded()
        sizingCell.setNeedsLayout()
        sizingCell.layoutIfNeeded()
        return sizingCell.cellContentHeight()
    }
}
