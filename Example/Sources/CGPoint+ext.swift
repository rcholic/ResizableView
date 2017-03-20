//
//  CGPoint+ext.swift
//  ResizableView
//
//  Created by Guoliang Wang on 3/19/17.
//  Copyright © 2017 Guoliang Wang. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    
    func distance(toPoint p: CGPoint) -> CGFloat {
        let dx = p.x - self.x
        let dy = p.y - self.y
        return sqrt(dx * dx + dy * dy)
    }
}
