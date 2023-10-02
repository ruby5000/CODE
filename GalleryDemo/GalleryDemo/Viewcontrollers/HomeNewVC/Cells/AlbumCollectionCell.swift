//
//  AlbumCollectionCell.swift
//  GalleryDemo
//
//  Created by darshan.faldu on 02/08/23.
//

import UIKit

class AlbumCollectionCell: UICollectionViewCell {

    @IBOutlet weak var img_albums: UIImageView!
    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var lbl_count: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.img_albums.layer.cornerRadius = 12
    }

}
