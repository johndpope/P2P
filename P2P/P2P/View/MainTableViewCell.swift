//
//  MainTableViewCell.swift
//  P2P
//
//  Created by Roma Babajanyan on 04/07/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
