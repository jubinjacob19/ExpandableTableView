//
//  DisclosureIndicator.swift
//  ExpandableTableView
//
//  Created by Jubin Jacob on 22/01/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit

enum ArrowDirection : Int {
    case Top
    case Bottom
}

class DisclosureIndicator: UIView {
    
    convenience init(direction:ArrowDirection) {
        self.init(frame:CGRectZero)
        self.direction = direction
        self.backgroundColor = UIColor.clearColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var direction : ArrowDirection?
    
    override func drawRect(rect: CGRect) {
        let width = rect.size.width
        let padding : CGFloat = 15
        let path = UIBezierPath()
        path.lineJoinStyle = CGLineJoin.Round
        path.lineWidth = 2.0
        
        if(self.direction == ArrowDirection.Bottom) {
            let origin = CGPointMake(padding/2, padding/2)
            path.moveToPoint(origin)
            path.addLineToPoint(CGPointMake(width/2, width-padding))
            path.addLineToPoint(CGPointMake(width-(padding/2), padding/2))
            UIColor.darkGrayColor().setStroke()
            path.stroke()
        }   else {
            let origin = CGPointMake(padding/2, width - padding)
            path.moveToPoint(origin)
            path.addLineToPoint(CGPointMake(width/2, padding/2))
            path.addLineToPoint(CGPointMake(width-(padding/2),width - padding))
            UIColor.darkGrayColor().setStroke()
            path.stroke()
        }

    }

}
