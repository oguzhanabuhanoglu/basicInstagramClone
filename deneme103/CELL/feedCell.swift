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

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var documentIDLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.backgroundColor = .systemBackground
        
        userEmailLabel.backgroundColor = .systemBackground
        userEmailLabel.textColor = .label
        
        commentLabel.backgroundColor = .systemBackground
        commentLabel.textColor = .label
        
        userImageView.backgroundColor = .systemBackground
        
        likeLabel.backgroundColor = .systemBackground
        likeLabel.textColor = .label
        
        likeButton.backgroundColor = .systemBackground
        likeButton.tintColor = .tintColor
        
        
    }
    
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func likeButtonClicked(_ sender: Any) {
        
    
        let firestoreDatabase = Firestore.firestore()
        
        if let likeCount = Int(likeLabel.text!){
            
            let likeStore = ["like" : likeCount + 1] as [String : Any]
            
            firestoreDatabase.collection("Posts").document(documentIDLabel.text!).setData(likeStore, merge: true)
            
        }
        
        
        
        
    }
    
}
