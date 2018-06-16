//
//  Data.swift
//  P2P
//
//  Created by Roma Babajanyan on 15/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import Foundation
import UIKit

struct cellData{
    let image: UIImage?
    let name: String?
}

class Data{
    var data = [cellData]()
    
    init(){
        data = []
    }
}
