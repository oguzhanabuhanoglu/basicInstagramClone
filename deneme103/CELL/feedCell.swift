//
//  feedCell.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 30.10.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore

class feedCell: UITableViewCell {

    
    static let identifier = "challangeCell"
    
    
     let profileImage : UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.backgroundColor = .systemBackground
        image.image = UIImage(named: "newPost")
        return image
    }()
     
    let usernameLabel : UILabel = {
       let label = UILabel()
        label.backgroundColor = .systemBackground
        label.textAlignment = .left
        label.textColor = .label
        return label
    }()
    
    let commentLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.numberOfLines = 3
        label.text = "spor challangenı kasdfhgdfghdfgjdfhjgdklsşfghmsdlfhgsdnfglhjdnsfşhlkjsdnfhşskdlfhşsdfljhndsşfjlh"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.textColor = .label
        return label
    }()
    
    let userImageView : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemBackground
        image.contentMode = .scaleAspectFill
        image.image = UIImage(named: "sisifos")
        return image
    }()
    
    let likeButton : UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 27, weight: UIImage.SymbolWeight.regular)
        let image = UIImage(systemName: "heart", withConfiguration: config)
        button.setImage(image, for: UIControl.State.normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .label
        return button
    }()
    
    
    let likeCountLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.textAlignment = .right
        label.textColor = .label
        label.text = "120"
        return label
    }()
   
    let documentIDLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemBackground
        label.textColor = .systemBackground
        return label
    }()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.clipsToBounds = true
        contentView.backgroundColor = .systemBackground
        
       
        contentView.addSubview(usernameLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(userImageView)
        contentView.addSubview(likeButton)
        contentView.addSubview(profileImage)
        contentView.addSubview(likeCountLabel)
        contentView.addSubview(documentIDLabel)
        
        likeButton.addTarget(self, action: #selector(likeButtonClicked), for: UIControl.Event.touchUpInside)
        
        
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let widht = contentView.frame.size.width
        let height = contentView.frame.size.height
        

        
        profileImage.frame = CGRect(x: widht * 0.08 - (height * 0.10) / 2, y: height * 0.09 - (height * 0.10) / 2, width: height * 0.08, height: height * 0.08)
        profileImage.layer.cornerRadius =  profileImage.frame.height / 2
        
        usernameLabel.frame = CGRect(x: widht * 0.45 - (widht * 0.56) / 2, y: height * 0.08 - (height * 0.06) / 2, width: widht * 0.56, height: height * 0.06)
        
        commentLabel.frame = CGRect(x: widht * 0.5 - (widht * 0.98) / 2, y: height * 0.82 - (height * 0.065) / 2 , width: widht * 0.98, height: height * 0.19)
        
        userImageView.frame = CGRect(x: widht * 0.5 - (widht * 0.95) / 2, y: height * 0.46 - (height * 0.62) / 2, width: widht * 0.95, height: height * 0.62)
        
        likeButton.frame = CGRect(x: widht * 0.05 - (height * 0.08) / 2, y: height * 0.82 - (height * 0.08) / 2, width: height * 0.065, height: height * 0.063)
        
        likeCountLabel.frame = CGRect(x: widht * 0.9 - (widht * 0.2) / 2, y: height * 0.82 - (height * 0.063) / 2, width: widht * 0.2, height: height * 0.063)
        
        documentIDLabel.frame = CGRect(x: widht * 0.5 - (widht * 0.2) / 2, y: height * 0.82 - (height * 0.063) / 2, width: widht * 0.2, height: height * 0.063)
        
        
    }
    
    @objc func likeButtonClicked(){
        
        let fd = Firestore.firestore()
        
        if let likeCount = Int(likeCountLabel.text!) {
            
            let likeStore = ["likes" : likeCount + 1] as [String : Any]
            
            fd.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
        }
        
    }
    
}
