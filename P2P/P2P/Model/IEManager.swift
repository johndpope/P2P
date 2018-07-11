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
    
    
    
    
}
