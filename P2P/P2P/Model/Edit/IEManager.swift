//
//  ImageEditorManager.swift
//  P2P
//
//  Created by Roma Babajanyan on 11/07/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import Foundation
import UIKit

class IEManager{
    var mainLayout: UIImageView?
    var tmpLayout: UIImageView?
    var lastPoint: CGPoint?
    
    init(_ image: UIImageView){
        mainLayout = image
        tmpLayout = image
    }
    
    func clean(){
        
        UIGraphicsBeginImageContext((self.mainLayout?.frame.size)!)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(red: 255.0, green: 255.0, blue: 255.0, alpha: 1.0)
        context?.fill(CGRect(x: 0, y: 0, width: (self.tmpLayout?.frame.size.width)!, height: (self.tmpLayout?.frame.size.height)!))
        self.mainLayout?.image = UIGraphicsGetImageFromCurrentImageContext()
        
       UIGraphicsEndImageContext()
        
    }
    
    func drawPoint(point: CGPoint, state: UIGestureRecognizerState){
        switch (state){
        case UIGestureRecognizerState.began:
            lastPoint = point
            break
        case UIGestureRecognizerState.changed:
            let currentPoint = point
            
            UIGraphicsBeginImageContext((self.mainLayout?.frame.size)!)
            self.mainLayout?.image?.draw(in: CGRect(x: 0, y: 0, width: (self.mainLayout?.layer.frame.size.width)!, height: (self.mainLayout?.layer.frame.size.height)!))
                
            UIGraphicsGetCurrentContext()?.move(to: lastPoint!)
            UIGraphicsGetCurrentContext()?.addLine(to: currentPoint)
            
            UIGraphicsGetCurrentContext()?.setLineCap(.round)
            UIGraphicsGetCurrentContext()?.setLineWidth(5.0)
            UIGraphicsGetCurrentContext()?.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 1)
            UIGraphicsGetCurrentContext()?.setBlendMode(.normal)
            
            UIGraphicsGetCurrentContext()?.strokePath()
            self.tmpLayout?.image = UIGraphicsGetImageFromCurrentImageContext()
            
            self.tmpLayout?.alpha = 1
            
            lastPoint = currentPoint
            UIGraphicsEndImageContext() // maybe no need in it
            
            break
        case UIGestureRecognizerState.ended:
            UIGraphicsBeginImageContext((self.mainLayout?.frame.size)!)
            self.mainLayout?.image?.draw(in: CGRect(x: 0, y: 0, width: (self.mainLayout?.frame.size.width)!, height: (mainLayout?.frame.size.height)!), blendMode: .normal, alpha: 1.0)
            
            self.tmpLayout?.image?.draw(in: CGRect(x: 0, y: 0, width: (self.tmpLayout?.frame.size.width)!, height: (tmpLayout?.frame.size.height)!), blendMode: .normal, alpha: 1.0)
            
            self.mainLayout?.image = UIGraphicsGetImageFromCurrentImageContext()
            self.tmpLayout?.image = nil
            
            UIGraphicsEndImageContext() // maybe no need in it possible errors maybe because of this take care about this
            break
        default:
            break
        }
    }
    
    
    
    
}
