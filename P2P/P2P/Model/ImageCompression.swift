//
//  ImageCompression.swift
//  P2P
//
//  Created by Roma Babajanyan on 05/07/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
}
