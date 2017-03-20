//
//  ResizableView+Events.swift
//  ResizableView
//
//  Created by Guoliang Wang on 3/17/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit

extension ResizableView {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let firstTouch = touches.first else { return }
        
        self.isActive = true
        delegate?.resizableView(self, didBegin: true)        

        anchorPoint = locateAnchorPoint(closeTo: firstTouch.location(in: self))
        if #available(iOS 9.1, *) {
            firstTouchPoint = firstTouch.preciseLocation(in: self.superview)
        } else {
            firstTouchPoint = firstTouch.location(in: self.superview)
        } // use superview's coord for resizing
        
        if !self.isResizing {
            // for translating/moving, use the view's self coordinate system
            if #available(iOS 9.1, *) {
                firstTouchPoint = firstTouch.preciseLocation(in: self)
            } else {
                firstTouchPoint = firstTouch.location(in: self)
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.isActive = true
        
        if self.isResizing {
            // resize using touch location
            if let referencePoint = touches.first?.location(in: self.superview) {
                resize(relativeTo: referencePoint)
            }
        } else {
            // translate using touch location
            if let destPoint = touches.first?.location(in: self) {
                translate(to: destPoint)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.resizableView(self, didEnd: true)
//        self.firstTouchPoint = .zero
        self.isActive = false
        self.delegate?.resizableView(self, didEnd: true)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.firstTouchPoint = .zero
        self.isActive = false
        self.delegate?.resizableView(self, didEnd: true)
    }
    
    fileprivate func translate(to point: CGPoint) {
        let dx = point.x - firstTouchPoint.x
        let dy = point.y - firstTouchPoint.y
        var centerPoint = CGPoint(x: self.center.x + dx, y: self.center.y + dy)
        
        if let parentView = self.superview, self.keepInsideParentView {
            
            let midX = self.bounds.midX
            let midY = self.bounds.midY
            
            if (centerPoint.x > parentView.bounds.size.width - midX) {
                centerPoint.x = parentView.bounds.size.width - midX
            }
            
            if (centerPoint.x < midX) {
                centerPoint.x = midX
            }
            
            if (centerPoint.y > parentView.bounds.size.height - midY) {
                centerPoint.y = parentView.bounds.size.height - midY
            }
            
            if (centerPoint.y < midY) {
                centerPoint.y = midY
            }
        }
        // disregard parent's view frame
        self.center = centerPoint
    }
    
    fileprivate func resize(relativeTo point: CGPoint) {
        
        guard self.isResizing else {
            return
        }
        
        guard let parentView = self.superview else {
            return
        }
        
        let parentWidth = parentView.bounds.size.width
        let parentHeight = parentView.bounds.size.height
        
        // check if outside of the superview
        if self.keepInsideParentView {
            if firstTouchPoint.x < self.padding {
                firstTouchPoint.x = self.padding
            }
            if firstTouchPoint.x > parentWidth - padding {
                firstTouchPoint.x = parentWidth - padding
            }
            
            if firstTouchPoint.y < padding {
                firstTouchPoint.y = padding
            }
            
            if firstTouchPoint.y > parentHeight - padding {
                firstTouchPoint.y = parentHeight - padding
            }
        }        
        
        // compute deltas
        var deltaW = anchorPoint.updatesW * (firstTouchPoint.x - point.x)
        let deltaX = anchorPoint.updatesX * (-1.0 * deltaW)
        var deltaH = anchorPoint.updatesH * (point.y - firstTouchPoint.y)
        let deltaY = anchorPoint.updatesY * (-1.0 * deltaH)
        
        // new frame
        var newX = self.frame.origin.x + deltaX
        var newY = self.frame.origin.y + deltaY
        var newWidth = self.width + deltaW
        var newHeight = self.height + deltaH
        
        if newWidth < minimumWidth {
            newWidth = self.width
            newX = self.frame.origin.x
        }
        
        if newHeight < minimumHeight {
            newHeight = self.height
            newY = self.frame.origin.y
        }
        
        // should not move offscreen
        if self.keepInsideParentView {
            if newX < parentView.bounds.origin.x {
                deltaW = self.frame.origin.x - parentView.bounds.origin.x
                newWidth = self.width + deltaW
                newX = parentView.bounds.origin.x
            }
            
            if newX + newWidth > parentView.bounds.origin.x + parentView.bounds.size.width {
                newWidth = parentView.bounds.size.width - newX
            }
            
            if newY < parentView.bounds.origin.y {
                deltaH = self.frame.origin.y - parentView.bounds.origin.y
                newHeight = self.height + deltaH
                newY = parentView.bounds.origin.y
            }
            
            if newY + newHeight > parentView.bounds.origin.y + parentView.bounds.size.height {
                newHeight = parentView.bounds.size.height - newY
            }
        }
        
        self.frame = CGRect(x: newX, y: newY, width: newWidth, height: newHeight)
        self.gripperBorder.frame.origin = self.frame.origin
        self.gripperBorder.frame = self.bounds.insetBy(dx: VIEW_INSET, dy: VIEW_INSET) // update border frame
        self.gripperBorder.setNeedsDisplay()
        firstTouchPoint = point // update the firstTouchPoint
    }
}
