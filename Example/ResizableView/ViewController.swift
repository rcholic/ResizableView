//
//  ViewController.swift
//  ResizableView
//
//  Created by rcholic on 03/19/2017.
//  Copyright (c) 2017 rcholic. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var resizableView: ResizableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        
        resizableView = ResizableView(frame: CGRect(x: 20, y: 50, width: 200, height: 200))
        resizableView.delegate = self
        
        self.view.addSubview(resizableView)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
}

extension ViewController: ResizableViewDelegate {
    
    func resizableView(_ resizableView: ResizableView, didEnd: Bool) {
        self.resizableView.hideGripper()
    }
    
    func resizableView(_ resizableView: ResizableView, didBegin: Bool) {
        self.view.bringSubview(toFront: resizableView)
        //        self.resizableView.showGripper()
    }
}
