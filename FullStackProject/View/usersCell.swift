//
//  usersCell.swift
//  FullStackProject
//
//  Created by DvOmar on 04/06/1443 AH.
//

import UIKit

class usersCell: UITableViewCell {

    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var lastMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    
}
