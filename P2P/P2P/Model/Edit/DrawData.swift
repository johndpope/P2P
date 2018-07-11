//
//  Drawer.swift
//  P2P
//
//  Created by Roma Babajanyan on 11/07/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

// TODO: Handle unsave pointer from Double

import Foundation
import UIKit

struct DData{
    var x: Double
    var y: Double
    var state: UIGestureRecognizerState
}

class DrawData{
    var x: Double?
    var y: Double?
    
    func initWithGestureState(state: UIGestureRecognizerState, point: CGPoint) -> DrawData{
        
        let data : NSMutableData?
        
        self.x = Double(point.x) // Size of Double and UIGestureRecognizerState are 8 bytes each
        self.y = Double(point.y)
        
        //let xPointer = UnsafePointer<Double>
        
        data?.append(&x, count: MemoryLayout<Double>.size(ofValue: self.x!))
        //data?.append(UnsafeBufferPointer<Double>.)
        
        return self
    }
}
