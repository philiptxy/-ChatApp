//
//  ContactsTableViewCell.swift
//  ChatApp
//
//  Created by Terence Chua on 12/02/2018.
//  Copyright © 2018 Philip Teow. All rights reserved.
//

import UIKit

class ContactsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
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
