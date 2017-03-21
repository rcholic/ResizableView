//
//  GripperBorder.swift
//  ResizableView
//
//  Created by Guoliang Wang on 3/18/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit

class GripperBorder: UIView {
    
    let gradColors: [CGFloat] = [0.4, 0.8, 1.0, 1.0, 0.0, 0.0, 1.0, 1.0]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func draw(_ rect: CGRect) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        
        // bounding box
        context?.setLineWidth(1.0)
        context?.setStrokeColor(self.tintColor.cgColor)
        let rectangle = self.bounds.insetBy(dx: BORDER_SIZE/2.0, dy: BORDER_SIZE/2.0)
        context?.addRect(rectangle)
        context?.strokePath()
        
        let topLeft = CGRect(x: 0, y: 0, width: BORDER_SIZE, height: BORDER_SIZE)
        let topRight = CGRect(x: self.width - BORDER_SIZE, y: 0, width: BORDER_SIZE, height: BORDER_SIZE)
        
        let bottomRight = CGRect(x: self.width - BORDER_SIZE, y: self.height - BORDER_SIZE, width: BORDER_SIZE, height: BORDER_SIZE)
        let bottomLeft = CGRect(x: 0, y: self.height - BORDER_SIZE, width: BORDER_SIZE, height: BORDER_SIZE)
        
        let topMiddle = CGRect(x: (self.width - BORDER_SIZE)/2.0, y: 0, width: BORDER_SIZE, height: BORDER_SIZE)
        
        let bottomMiddle = CGRect(x: (self.width - BORDER_SIZE)/2.0, y: self.height - BORDER_SIZE, width: BORDER_SIZE, height: BORDER_SIZE)
        
        let middleLeft = CGRect(x: 0, y: (self.height - BORDER_SIZE) / 2.0, width: BORDER_SIZE, height: BORDER_SIZE)
        
        let middleRight = CGRect(x: self.width - BORDER_SIZE, y: (self.height - BORDER_SIZE) / 2.0, width: BORDER_SIZE, height: BORDER_SIZE)
        
        let baseSpace = CGColorSpaceCreateDeviceRGB()
        let gradient = CGGradient.init(colorSpace: baseSpace, colorComponents: gradColors, locations: nil, count: 2)
        
        // fill each anchor point with the gradient then stroke the border
        let allPoints: [CGRect] = [topLeft, topRight, bottomRight,
                                   bottomLeft, topMiddle, bottomMiddle,
                                   middleLeft, middleRight]
        
        for gripper in allPoints {
            context?.saveGState()
            context?.addEllipse(in: gripper)
            context?.clip()
            let startPoint = CGPoint(x: gripper.midX, y: gripper.minY)
            let endPoint = CGPoint(x: gripper.midX, y: gripper.maxY)
            context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.drawsBeforeStartLocation)
            context?.restoreGState()
            context?.strokeEllipse(in: gripper.insetBy(dx: 1, dy: 1))
        }
        
    }
    
    fileprivate func commonInit() {
        self.backgroundColor = UIColor.clear
    }
    
    internal var width: CGFloat {
        return self.bounds.size.width
    }
    
    internal var height: CGFloat {
        return self.bounds.size.height
    }

}
