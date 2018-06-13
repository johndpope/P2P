//
//  CustomTableViewCell.swift
//  P2P
//
//  Created by Roma Babajanyan on 11/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellView: UIView!
    
    @IBOutlet weak var imageThumbnail: UIImageView!
    
    @IBOutlet weak var imageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    
}
