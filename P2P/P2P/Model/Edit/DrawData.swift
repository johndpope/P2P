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
        
        //let data : Data?
        
        self.x = Double(point.x) // Size of Double and UIGestureRecognizerState are 8 bytes each
        self.y = Double(point.y)
        
        /*Sample
         
         var x: Double = 0.99043125417
         var length = MemoryLayout<Double>.size // -> 8
         var x_data = NSData(bytes: &x, length: length)
         
         var buffer = [UInt8](repeating: 0x00, count: MemoryLayout<Double>.size)
         x_data.getBytes(&buffer, length: buffer.count)*/
        
        //let data = Data(bytes: <#T##Array<UInt8>#>)
        
        //let xPointer = UnsafePointer<Double>
        //data?.append(UnsafeBufferPointer<Double>.)
        
        return self
    }
}
