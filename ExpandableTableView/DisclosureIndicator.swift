//
//  DisclosureIndicator.swift
//  ExpandableTableView
//
//  Created by Jubin Jacob on 22/01/16.
//  Copyright © 2016 J. All rights reserved.
//

import UIKit

enum ArrowDirection : Int {
    case top
    case bottom
}

class DisclosureIndicator: UIView {
    
    convenience init(direction:ArrowDirection) {
        self.init(frame:CGRect.zero)
        self.direction = direction
        self.backgroundColor = UIColor.clear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var direction : ArrowDirection?
    
    override func draw(_ rect: CGRect) {
        let width = rect.size.width
        let padding : CGFloat = 15
        let path = UIBezierPath()
        path.lineJoinStyle = CGLineJoin.round
        path.lineWidth = 2.0
        
        if(self.direction == ArrowDirection.bottom) {
            let origin = CGPoint(x: padding/2, y: padding/2)
            path.move(to: origin)
            path.addLine(to: CGPoint(x: width/2, y: width-padding))
            path.addLine(to: CGPoint(x: width-(padding/2), y: padding/2))
            UIColor.darkGray.setStroke()
            path.stroke()
        }   else {
            let origin = CGPoint(x: padding/2, y: width - padding)
            path.move(to: origin)
            path.addLine(to: CGPoint(x: width/2, y: padding/2))
            path.addLine(to: CGPoint(x: width-(padding/2),y: width - padding))
            UIColor.darkGray.setStroke()
            path.stroke()
        }

    }

}
