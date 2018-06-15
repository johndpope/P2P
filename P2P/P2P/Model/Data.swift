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
        data = [cellData(image: #imageLiteral(resourceName: "IMG_3"), name: "IMG_1"),
                cellData(image: #imageLiteral(resourceName: "IMG_5"), name: "IMG_2"),
                cellData(image: #imageLiteral(resourceName: "IMG_4"), name: "IMG_3")]
    }
}
