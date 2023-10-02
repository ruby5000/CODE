//
//  StoriesCollectionCell.swift
//  GalleryDemo
//
//  Created by darshan.faldu on 02/08/23.
//

import UIKit

class StoriesCollectionCell: UICollectionViewCell {

    @IBOutlet weak var img_stories: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.img_stories.layer.cornerRadius = 37.5
    }

}
