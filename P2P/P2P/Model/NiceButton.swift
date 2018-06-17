//
//  NiceButton.swift
//  P2P
//
//  Created by Roma Babajanyan on 17/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import Foundation

import UIKit


extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
}
