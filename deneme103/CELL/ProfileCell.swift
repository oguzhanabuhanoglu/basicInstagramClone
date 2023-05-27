//
//  ProfileCell.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 7.11.2022.
//

import UIKit
import SDWebImage

class ProfileCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    static let identifier = "ProfileCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
    }
    
    
    
    public func configure(with url: URL){
        imageView.sd_setImage(with: url)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = contentView.bounds
    }
    
    static func nib() -> UINib{
        return UINib(nibName: "ProfileCell", bundle: nil)
    }
    
    

}
