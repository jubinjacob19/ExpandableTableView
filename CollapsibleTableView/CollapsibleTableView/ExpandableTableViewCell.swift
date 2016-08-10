//
//  ExpandableTableViewCell.swift
//  ExpandableTableView
//
//  Created by Jubin Jacob on 22/01/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit

struct ItemModel {
    let question : String
    let answer : String
}

class ExpandableTableViewCell: UITableViewCell {
    

    private lazy var questionLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 3
        lbl.textColor = UIColor.blackColor()
        lbl.font = UIFont.systemFontOfSize(13.0)
        return lbl
    } ()
    
    private lazy var answerLabel : UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 0
        lbl.textColor = UIColor.darkGrayColor()
        lbl.font = UIFont.systemFontOfSize(11.0)
        return lbl
    } ()
    
    private lazy var topSpacerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var spacerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    private lazy var bottomSpacerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    } ()
    
    lazy var disclosureView : DisclosureIndicator = {
        let view = DisclosureIndicator(direction: ArrowDirection.Bottom)
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
    
    private func addSubviews() {
        self.contentView.addSubview(self.topSpacerView)
        self.contentView.addSubview(self.questionLabel)
        self.contentView.addSubview(self.disclosureView)
        self.contentView.addSubview(self.spacerView)
        self.contentView.addSubview(self.answerLabel)
        self.contentView.addSubview(self.bottomSpacerView)
        self.setLayoutConstraints()
    }
    
    private func setLayoutConstraints() {
        let views = ["qn":self.questionLabel,"ans":self.answerLabel,"view":self.spacerView,"top":self.topSpacerView,"btm":self.bottomSpacerView,"btn":self.disclosureView]
        let metrics = ["padding":10]
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(padding)-[qn]-(padding)-[btn(==32)]-(padding)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(padding)-[ans]-(padding)-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[view]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[top]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[btm]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[top(==padding)][qn][view(==padding)][ans][btm(==padding)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: metrics, views: views))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.disclosureView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: 32))
        self.contentView.addConstraint(NSLayoutConstraint(item: self.disclosureView, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self.questionLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
    }

    func setCellContent(item : ItemModel, isExpanded : Bool) {
        self.questionLabel.text = item.question
        self.answerLabel.text = isExpanded ? item.answer : ""
        self.disclosureView.direction = isExpanded ? ArrowDirection.Top : ArrowDirection.Bottom
        self.disclosureView.setNeedsDisplay()
        
    }
    
    func cellContentHeight()->CGFloat {
        return self.questionLabel.intrinsicContentSize().height + self.answerLabel.intrinsicContentSize().height + 35.0
    }

}
