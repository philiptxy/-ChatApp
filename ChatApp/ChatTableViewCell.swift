//
//  ChatTableViewCell.swift
//  ChatApp
//
//  Created by Philip Teow on 13/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class ChatTableViewCell: UITableViewCell {
    @IBOutlet weak var widthRightLabel: NSLayoutConstraint!
    @IBOutlet weak var widthLeftLabel: NSLayoutConstraint!
    @IBOutlet weak var leftMsgLabel: UILabel!
    @IBOutlet weak var rightMsgLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        rightMsgLabel.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
