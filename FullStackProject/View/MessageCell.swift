//
//  MessageCell.swift
//  FullStackProject
//
//  Created by DvOmar on 02/06/1443 AH.
//

import UIKit

class MessageCell: UITableViewCell {
    
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var spaceLeft: UILabel!
    @IBOutlet weak var contentMessage: UILabel!
    @IBOutlet weak var spaseRight: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius=view.frame.size.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
