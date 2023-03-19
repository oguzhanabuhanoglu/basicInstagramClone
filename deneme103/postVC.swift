//
//  PostViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 29.12.2022.
//

import UIKit
import SDWebImage

class postVC: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var postComment: UILabel!
    
    var selectedPost : Collection?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if let post = selectedPost{
            
            usernameLabel.text = UserSingleton.sharedUserInfo.username
            postImage.sd_setImage(with: URL(string: post.imageUrl))
            postComment.text = post.postComment
            
            }
       
    }
    


}
