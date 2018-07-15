
//
//  Compate.swift
//  P2P
//
//  Created by Roma Babajanyan on 15/07/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    func isEqualToImage(image: UIImage) -> Bool {
        let data1: NSData = UIImagePNGRepresentation(self)!
        let data2: NSData = UIImagePNGRepresentation(image)!
        return data1.isEqual(data2)
    }
    
}
