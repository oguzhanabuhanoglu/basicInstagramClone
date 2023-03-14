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
    }
    
    
    
    public func configure(with url: URL){
        imageView.sd_setImage(with: url)
    }
    
    
    static func nib() -> UINib{
        return UINib(nibName: "ProfileCell", bundle: nil)
    }
    
    

}
