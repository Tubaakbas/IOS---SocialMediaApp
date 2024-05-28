//
//  FeedTableViewCell.swift
//  SocialMediaApp
//
//  Created by iOS-Lab11 on 28.05.2024.
//

import UIKit

class FeedTableViewCell: UITableViewCell {

    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var yorumText: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
