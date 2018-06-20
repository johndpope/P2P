//
//  SetUpCellTableViewCell.swift
//  P2P
//
//  Created by Roma Babajanyan on 20/06/2018.
//  Copyright © 2018 Roma Babajanyan. All rights reserved.
//

import UIKit

class SetUpCellTableViewCell: UITableViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
