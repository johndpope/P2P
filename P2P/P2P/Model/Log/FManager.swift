//
//  FManager.swift
//  P2P
//
//  Created by Roma Babajanyan on 14/07/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import Foundation
import UIKit

class Loger {
    
    static func log(info: String, name: String){
        //FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        
        var text: String?
        
        let fileURL = directory.appendingPathComponent(name)
        do{
            let fInfo = try String(contentsOf: fileURL, encoding: .utf8)
            text = fInfo + info
        } catch{
            print(error.localizedDescription)
        }
    
        
        do {
            try text!.write(to: fileURL, atomically: false, encoding: .utf8)
            
        }
        catch{
            print(error.localizedDescription)
        }
    }
}
