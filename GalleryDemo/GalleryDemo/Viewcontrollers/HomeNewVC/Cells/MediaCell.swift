//
//  MediaCell.swift
//  GalleryDemo
//
//  Created by darshan.faldu on 03/08/23.
//

import UIKit

class MediaCell: UITableViewCell {

    @IBOutlet weak var img_icon: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        img_icon.layer.cornerRadius = 6
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
