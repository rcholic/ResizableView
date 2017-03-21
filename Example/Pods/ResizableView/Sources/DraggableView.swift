//
//  ResizableView.swift
//  ResizableView
//
//  Created by Guoliang Wang on 3/17/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import UIKit

@objc
protocol ResizableViewDelegate: class {
    
    @objc func resizableView(_ resizableView: ResizableView, didBegin: Bool)
    @objc func resizableView(_ resizableView: ResizableView, didEnd: Bool)
}

internal struct AnchorPoint {
    let updatesW: CGFloat
    let updatesH: CGFloat
    let updatesX: CGFloat
    let updatesY: CGFloat
    
    init(x: CGFloat, y: CGFloat, height: CGFloat, width: CGFloat) {
        self.updatesX = x
        self.updatesY = y
        self.updatesH = height
        self.updatesW = width        
    }
}

internal struct AnchorPointPair {
    let point: CGPoint
    let anchor: AnchorPoint
}

class ResizableView: UIView {
    
//    let RADIUS: CGFloat = 3.0
    
    var gripperBorder: GripperBorder!
    
    var content: UIView!
    
    var firstTouchPoint: CGPoint = .zero
    
    var keepInsideParentView: Bool = true
    
    let padding: CGFloat = VIEW_INSET + BORDER_SIZE / 2.0
    
    let minimumWidth: CGFloat = 30.0
    
    let minimumHeight: CGFloat = 30.0
    
    var anchorPoint: AnchorPoint = centerAnchor {
        didSet {
            // check if it's resizing
            self.isResizing = (anchorPoint.updatesH != 0 || anchorPoint.updatesW != 0 || anchorPoint.updatesX != 0 || anchorPoint.updatesY != 0)
        }
    }
    
    var isResizing: Bool = false
    
    var isActive: Bool = false {
        didSet {
            self.gripperBorder.isHidden = !isActive
        }
    }
    
    var image: UIImage? = nil {
        didSet {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFill
            imageView.frame = self.content.frame
            self.content = imageView
        }
    }
    
    var contentView: UIView? = nil {
        didSet {
            guard let view = contentView else { return }
            view.frame = self.content.frame
            self.content = view
        }
    }
    
    weak var delegate: ResizableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupContentView()
    }
    
    fileprivate func commonInit() {
        self.backgroundColor = UIColor.clear // #colorLiteral(red: 0, green: 0.5694751143, blue: 1, alpha: 1)
        gripperBorder = GripperBorder(frame: self.bounds.insetBy(dx: VIEW_INSET, dy: VIEW_INSET))
        gripperBorder.isHidden = true
        content = UIView()
        content.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) // TODO: change the default color
        
        pinchGesture.addTarget(self, action: #selector(self.didPinchView(sender:)))
        addGestureRecognizer(pinchGesture)
    }
    
    fileprivate func setupContentView() {
        content.removeFromSuperview()
        content.frame = self.bounds.insetBy(dx: padding, dy: padding)
        
        self.addSubview(content)
        gripperBorder.setNeedsDisplay()
        self.addSubview(gripperBorder)
    }
    
    deinit {
        gripperBorder.removeFromSuperview()
        gripperBorder = nil
        content.removeFromSuperview()
        content = nil
        
        removeGestureRecognizer(pinchGesture)
        self.removeFromSuperview()
    }
    
    // MARK: locate the anchor point closes to the touch point
    internal func locateAnchorPoint(closeTo point: CGPoint) -> AnchorPoint {
        
        var anchor = centerAnchor
        var minDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        // should we apply a minimum distance to anchor point for considering resizing?
        anchorPoints.forEach {
            let dist = point.distance(toPoint: $0.point)
//            NSLog("dist: \(dist)")
            if dist < minDistance {
                minDistance = dist
                anchor = $0.anchor
            }
        }
        
        return anchor
    }
    
//    internal func generateBorderGrabber(rect: CGRect) -> CAShapeLayer {
//        
//        let leftPoint = CGPoint(x: rect.minX, y: rect.height/2.0)
//        let circleL = UIBezierPath(roundedRect: CGRect(x: rect.minX, y: rect.midY, width: 2.0 * RADIUS, height: 2.0 * RADIUS), cornerRadius: RADIUS)
//        let circleShape = CAShapeLayer()
//        circleShape.path = circleL.cgPath
//        circleShape.position = leftPoint
//        circleShape.fillColor = UIColor.red.cgColor
//        circleShape.strokeColor = UIColor.red.cgColor
//        
//        return circleShape
//    }
    
    private func distance(p1: CGPoint, p2: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(p1.x) - Float(p2.x), Float(p1.y) - Float(p2.y)))
    }
    
    @objc private func didPinchView(sender: UIPinchGestureRecognizer) {
        NSLog("did pinch view, scale: \(sender.scale)")
        self.transform = CGAffineTransform(scaleX: sender.scale, y: sender.scale)
    }
    
    open func showGripper() {
        self.gripperBorder.isHidden = false
    }
    
    open func hideGripper() {
        self.gripperBorder.isHidden = true
    }
    
    internal var width: CGFloat {
        return self.bounds.size.width
    }
    
    internal var height: CGFloat {
        return self.bounds.size.height
    }
    
    internal lazy var pinchGesture: UIPinchGestureRecognizer = {
        return UIPinchGestureRecognizer()
    }()
    
    internal lazy var anchorPoints: [AnchorPointPair] = {
        
        let minX = self.bounds.minX + self.padding
        let maxX = self.bounds.maxX - self.padding
        
        let minY = self.bounds.minY + self.padding
        let maxY = self.bounds.maxY - self.padding
        
        var pointPairs: [AnchorPointPair] = []
        let topLeft = CGPoint(x: minX, y: minY)
        let topMiddle = CGPoint(x: self.bounds.midX, y: minY)
        let topRight = CGPoint(x: maxX, y: minY)
        let rightMiddle = CGPoint(x: maxX, y: self.bounds.midY)
        let bottomRight = CGPoint(x: maxX, y: maxY)
        let bottomMiddle = CGPoint(x: self.bounds.midX, y: maxY)
        let bottomLeft = CGPoint(x: minX, y: maxY)
        let leftMiddle = CGPoint(x: minX, y: self.bounds.midY)
        let centerPoint = self.center
        
        pointPairs.append(AnchorPointPair(point: topLeft, anchor: topLeftAnchor))
        pointPairs.append(AnchorPointPair(point: topMiddle, anchor: topMiddleAnchor))
        pointPairs.append(AnchorPointPair(point: topRight, anchor: topRightAnchor))
        pointPairs.append(AnchorPointPair(point: rightMiddle, anchor: rightMiddleAnchor))
        
        pointPairs.append(AnchorPointPair(point: bottomRight, anchor: bottomRightAnchor))
        pointPairs.append(AnchorPointPair(point: bottomMiddle, anchor: bottomMiddleAnchor))
        pointPairs.append(AnchorPointPair(point: bottomLeft, anchor: bottomLeftAnchor))
        pointPairs.append(AnchorPointPair(point: leftMiddle, anchor: leftMiddleAnchor))
        
        pointPairs.append(AnchorPointPair(point: centerPoint, anchor: centerAnchor))
        
        return pointPairs
    }()
}
