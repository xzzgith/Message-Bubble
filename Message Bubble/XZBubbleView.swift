//
//  XZBubbleView.swift
//  Message Bubble
//
//  Created by Felix on 2017/4/10.
//  Copyright © 2017年 FREEDOM. All rights reserved.
//

import UIKit

class XZBubbleView: UIView {

    var selfFrame: CGRect
    var color: UIColor
    var baseColor:UIColor
    
    var springRatio: CGFloat = 10
    var r1: CGFloat = 10
    var r2: CGFloat = 10
    
    var x1: CGFloat?
    var x2: CGFloat?
    var y1: CGFloat?
    var y2: CGFloat?
    var cosD: CGFloat?
    var sinD: CGFloat?
    
    var originCenter: CGPoint?
    var pointA: CGPoint?
    var pointB: CGPoint?
    var pointC: CGPoint?
    var pointD: CGPoint?
    var pointE: CGPoint?
    var pointF: CGPoint?

    var originBubble: UIView?
    var slideBubble: UIView?
    var containerView: UIView?
    
    lazy var shapeLayer = CAShapeLayer()
    var path: UIBezierPath?
    
    init(showIn superView: UIView, point: CGPoint, color:UIColor) {
      
        selfFrame = CGRect(x: point.x, y: point.y, width: 20, height: 20)
        self.color = color
        baseColor = color
        containerView = superView
        super.init(frame: selfFrame)
        self.setup(frame: selfFrame)
        containerView!.addSubview(self)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(frame: CGRect) {
        originBubble = UIView(frame: CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frame.size.height))
        originBubble?.layer.cornerRadius = r1
        originBubble?.backgroundColor = baseColor
        containerView?.addSubview(originBubble!)
        originCenter = originBubble?.center

        
        slideBubble = UIView(frame: CGRect(x: frame.origin.x+1, y: frame.origin.y, width: frame.size.width, height: frame.size.width))
        slideBubble!.layer.cornerRadius = r2
        slideBubble!.backgroundColor = baseColor
        containerView!.addSubview(slideBubble!)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(XZBubbleView.panBubble(pan:)))
        self.addGestureRecognizer(pan)
        
    }
    
    func panBubble(pan: UIPanGestureRecognizer) {
        let point = pan.location(in: containerView)
        
        switch pan.state {
        case UIGestureRecognizerState.began:
                originBubble!.isHidden = false
                color = baseColor
                shapeLayer.backgroundColor = color.cgColor
            
        case UIGestureRecognizerState.changed:
                slideBubble!.center = point
                if Double(r1) < 3 {
                    color = UIColor.clear
                    originBubble!.isHidden = true
                    shapeLayer.removeFromSuperlayer()
                }
                self.slideWrap()
            
        case UIGestureRecognizerState.ended, UIGestureRecognizerState.failed, UIGestureRecognizerState.cancelled:
            if Double(r1) < 3 {
                print("slideBubble Boom")
            }
            
            originBubble?.isHidden = true
            color = UIColor.clear
            shapeLayer.removeFromSuperlayer()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0, options: .curveEaseInOut, animations: { 
                self.slideBubble!.center = self.originCenter!
                self.color = self.baseColor
            }, completion: { (finished: Bool) in
                self.r1 = self.selfFrame.size.width
            })
            
        default: break
            
        }
    }
    
    func slideWrap() {
        x1 = originBubble!.center.x
        y1 = originBubble!.center.y
        x2 = slideBubble!.center.x
        y2 = slideBubble!.center.y
        
        let xDistance = (x2!-x1!)*(x2!-x1!)
        let yDistance = (y2!-y1!)*(y2!-y1!)
        
        let centerDistance = sqrt(Double(xDistance) + Double(yDistance))
        if centerDistance == 0 {
            cosD = 0
            sinD = 1
        }else{
            cosD = (y2!-y1!) / CGFloat(centerDistance);
            sinD = (x2!-x1!) / CGFloat(centerDistance);
        }
        
        r1 = selfFrame.size.width/2  - CGFloat(centerDistance)/springRatio;
        
        pointA = CGPoint(x: x1!+r1*cosD!, y: y1!-r1*sinD!)
        pointB = CGPoint(x: x2!+r2*cosD!, y: y2!-r2*sinD!);
        pointC = CGPoint(x: x2!-r2*cosD!, y: y2!+r2*sinD!);
        pointD = CGPoint(x: x1!-r1*cosD!, y: y1!+r1*sinD!);
        pointE = CGPoint(x: (pointD?.x)!+(CGFloat(centerDistance)/2)*sinD!, y: (pointD?.y)!+(CGFloat(centerDistance)/2)*cosD!);
        pointF = CGPoint(x: (pointA?.x)!+(CGFloat(centerDistance)/2)*sinD!, y: (pointA?.y)!+(CGFloat(centerDistance)/2)*cosD!);

        self.drawPath()
    }
    
    func drawPath() {
        originBubble?.bounds = CGRect(x: 0, y: 0, width: r1 * 2, height: r1 * 2)
        originBubble?.layer.cornerRadius = r1
      
        path = UIBezierPath()
        path!.move(to: pointD!)
        path!.addQuadCurve(to: pointC!, controlPoint: pointE!)
        path!.addLine(to: pointB!)
        path!.addQuadCurve(to: pointA!, controlPoint: pointF!)
        path!.move(to: pointD!)
        
        if originBubble?.isHidden == false {
            shapeLayer.path = path!.cgPath
            shapeLayer.fillColor = baseColor.cgColor
            containerView?.layer .insertSublayer(shapeLayer, below: slideBubble?.layer)
        }
    }
    
    override func removeFromSuperview() {
        originBubble!.removeFromSuperview()
        slideBubble!.removeFromSuperview()
        super.removeFromSuperview()
    }
    
    deinit {
        debugPrint("释放")
    }
}
