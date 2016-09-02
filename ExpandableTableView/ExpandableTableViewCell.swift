//
//  ExpandableTableViewCell.swift
//  ExpandableTableView
//
//  Created by Jubin Jacob on 22/01/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit

public struct ItemModel {
    public let question : String
    public let answer : String
    public init(question:String, answer:String) {
        self.question = question
        self.answer = answer
    }
}

class ExpandableTableViewCell: UITableViewCell {
    

    fileprivate lazy var questionLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 3
        lbl.textColor = UIColor.black
        lbl.font = UIFont.systemFont(ofSize: 13.0)
        return lbl
    } ()
    
    fileprivate lazy var answerLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.darkGray
        lbl.font = UIFont.systemFont(ofSize: 11.0)
        return lbl
    } ()
    
    fileprivate lazy var topSpacerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    fileprivate lazy var spacerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    fileprivate lazy var bottomSpacerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    lazy var disclosureView : DisclosureIndicator = {
        let view = DisclosureIndicator(direction: ArrowDirection.bottom)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func addSubviews() {
        self.contentView.addSubview(self.topSpacerView)
        self.contentView.addSubview(self.questionLabel)
        self.contentView.addSubview(self.disclosureView)
        self.contentView.addSubview(self.spacerView)
        self.contentView.addSubview(self.answerLabel)
        self.contentView.addSubview(self.bottomSpacerView)
        self.setLayoutConstraints()
    }
    
    fileprivate func setLayoutConstraints() {
        let views = ["qn":self.questionLabel,"ans":self.answerLabel,"view":self.spacerView,"top":self.topSpacerView,"btm":self.bottomSpacerView,"btn":self.disclosureView]
        let metrics = ["padding":10]
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[qn]-(padding)-[btn(==32)]-(padding)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(padding)-[ans]-(padding)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[top]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[btm]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[top(==padding)][qn][view(==padding)][ans][btm(==padding)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.disclosureView, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: 32))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.disclosureView, attribute: NSLayoutAttribute.centerY, relatedBy: NSLayoutRelation.equal, toItem: self.questionLabel, attribute: NSLayoutAttribute.centerY, multiplier: 1, constant: 0))
    }

    func setCellContent(_ item : ItemModel, isExpanded : Bool) {
        self.questionLabel.text = item.question
        self.answerLabel.text = isExpanded ? item.answer : ""
        self.disclosureView.direction = isExpanded ? ArrowDirection.top : ArrowDirection.bottom
        self.disclosureView.setNeedsDisplay()
        
    }
    
    func cellContentHeight()->CGFloat {
        return self.questionLabel.intrinsicContentSize.height + self.answerLabel.intrinsicContentSize.height + 35.0
    }

}
