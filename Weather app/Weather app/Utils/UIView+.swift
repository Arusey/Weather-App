//
//  UIView+.swift
//  Weather app
//
//  Created by Kevin Lagat on 03/02/2022.
//

import Foundation
import UIKit

extension UIView {
    
    /**
    Adds autolayout constraints to innerView to center it in its superview and fix its size.
    `innerView` should have a superview.
    */
    func centerViewInSuperview() {
        assert(self.superview != nil, "`view` should have a superview")
        
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraintH = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.centerX,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: superview,
            attribute: NSLayoutConstraint.Attribute.centerX,
            multiplier: 1,
            constant: 0
        )
        let constraintV = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.centerY,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: superview,
            attribute: NSLayoutConstraint.Attribute.centerY,
            multiplier: 1,
            constant: 0
        )
        let constraintWidth = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.width,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: frame.size.width
        )
        let constraintHeight = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: frame.size.height
        )
        superview!.addConstraints([constraintV, constraintH, constraintWidth, constraintHeight])
    }
}


