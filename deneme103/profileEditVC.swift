//
//  profileEditVC.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 19.03.2023.
//

import UIKit
import FirebaseStorage
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore


class profileEditVC: UIViewController {

    let profileImage = UIImageView()
    let usernameText = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        let widht = view.frame.size.width
        let height = view.frame.size.height

        
        profileImage.frame = CGRect(x: widht * 0.5 - 150/2, y: height * 0.19 - 150 / 2, width: 150, height: 150)
        profileImage.image = UIImage(named: "plus")
        profileImage.backgroundColor = .black
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.isUserInteractionEnabled = true
        view.addSubview(profileImage)
        
        
        
        //USERNAME TEXT FİELD
        usernameText.frame = CGRect(x: widht * 0.5 - widht * 0.4, y: height * 0.35 - 33/2, width: widht * 0.8, height: 33)
        usernameText.placeholder = "Username"
        usernameText.backgroundColor = .white
        usernameText.textColor = .black
        view.addSubview(usernameText)
        
        
        //NEXT BUTTON
        let updateButton = UIButton()
        updateButton.frame = CGRect(x: widht * 0.5 - widht * 0.45, y: height * 0.45 - 40/2, width: widht * 0.9, height: 40)
        updateButton.setTitle("Update", for: UIControl.State.normal)
        updateButton.backgroundColor = .tertiaryLabel
        updateButton.setTitleColor(UIColor.systemPurple, for: UIControl.State.normal)
        updateButton.layer.masksToBounds = true
        updateButton.layer.cornerRadius = 20
        view.addSubview(updateButton)
        
        updateButton.addTarget(self, action: #selector(updateProfile), for: UIControl.Event.touchUpInside)
    }
    
    
    @objc func updateProfile(){
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("profileImages")
        
        if let data = profileImage.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imageRef = mediaFolder.child("\(uuid).jpg")
            
            imageRef.putData(data) { metadata, error in
                if error != nil {
                    
                    self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
                }else{
                    
                    imageRef.downloadURL { url, error in
                        if error == nil {

                            let imageUrl = url?.absoluteString
                            
                            // FİRESTORE
                            let firestore = Firestore.firestore()
                            
                            //firestore.collection("Pofile").whereField("username", isEqualTo: )
                            
                            
                            
                            
                            
                            
                            
                            
                            
        }
        
    }
    
                }
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
