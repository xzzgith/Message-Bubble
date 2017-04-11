//
//  ViewController.swift
//  Message Bubble
//
//  Created by Felix on 2017/4/10.
//  Copyright © 2017年 FREEDOM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    var bubble: XZBubbleView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        bubble = XZBubbleView(showIn: view, point: CGPoint(x: 60, y: 620), color: UIColor.black)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        
//        let point = touches.first?.location(in: view)
//        print("x = \(point?.x),y = \(point?.y)")
//        bubble?.removeFromSuperview()
//        bubble = nil
//    }

}

