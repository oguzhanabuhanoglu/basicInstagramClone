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


class profileEditVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //check
    let profileImage = UIImageView()
    let usernameText = UITextField()
    let biografiText = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        let widht = view.frame.size.width
        let height = view.frame.size.height

        
        profileImage.frame = CGRect(x: widht * 0.5 - 150/2, y: height * 0.19 - 150 / 2, width: 150, height: 150)
        profileImage.image = UIImage(systemName: "plus.circle")
        profileImage.backgroundColor = .systemBackground
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        profileImage.contentMode = .scaleToFill
        profileImage.tintColor = .label
        profileImage.isUserInteractionEnabled = true
        profileImage.layer.borderWidth = 1
        profileImage.layer.borderColor = UIColor.label.cgColor
        view.addSubview(profileImage)
        
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImages))
        profileImage.addGestureRecognizer(gestureRecognizer)
        
        
        
        //USERNAME TEXT FİELD
        usernameText.frame = CGRect(x: widht * 0.5 - widht * 0.4, y: height * 0.35 - 33/2, width: widht * 0.8, height: 33)
        usernameText.placeholder = "Username"
        usernameText.backgroundColor = .secondarySystemBackground
        usernameText.textColor = .label
        view.addSubview(usernameText)
        
        //BİOGRAFİ TEXT
        biografiText.frame = CGRect(x: widht * 0.5 - widht * 0.4, y: height * 0.41 - 33/2, width: widht * 0.8, height: 33)
        biografiText.placeholder = "Biografi"
        biografiText.backgroundColor = .secondarySystemBackground
        biografiText.textColor = .label
        view.addSubview(biografiText)
        
        
        //NEXT BUTTON
        let updateButton = UIButton()
        updateButton.frame = CGRect(x: widht * 0.5 - widht * 0.45, y: height * 0.50 - 40/2, width: widht * 0.9, height: 40)
        updateButton.setTitle("Update", for: UIControl.State.normal)
        updateButton.backgroundColor = .secondarySystemBackground
        updateButton.setTitleColor(UIColor.label, for: UIControl.State.normal)
        updateButton.layer.masksToBounds = true
        updateButton.layer.cornerRadius = 20
        updateButton.layer.borderColor = UIColor.label.cgColor
        updateButton.layer.borderWidth = 1
        view.addSubview(updateButton)
        
        updateButton.addTarget(self, action: #selector(updateProfile), for: UIControl.Event.touchUpInside)
    }
    
    @objc func selectImages(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
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
                    
                    self.makeAlert(titleInput: "Error", messageInput: error!.localizedDescription ?? "Error")
                }else{
                    
                    imageRef.downloadURL { url, error in
                        if error == nil {

                            let imageUrl = url?.absoluteString
                            
                            // FİRESTORE
                            let firestore = Firestore.firestore()
                            
                            firestore.collection("Profile").whereField("username", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription)
                                    
                                }else{
                                    
                                    if snapshot?.isEmpty == false && snapshot != nil {
                                        for document in snapshot!.documents{
                                            
                                            let documentId = document.documentID
                                            
                                            let chancingDictionary = ["username" : self.usernameText.text, "profileImageUrl" : imageUrl]
                                            
                                            
                                            firestore.collection("Profile").document(documentId).updateData(chancingDictionary) { error in
                                                if error != nil {
                                                    
                                                    self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription ?? "Error!!")
                                                    
                                                    
                                                }else{
                                                    
                                                    self.tabBarController?.selectedIndex = 3
                                                    self.profileImage.image = UIImage(named: "plus")
                                                }
                                            }
                                            
                                        }
                                    }
                                    
                                }
                                
                                firestore.collection("Posts").whereField("postedBy", isEqualTo: UserSingleton.sharedUserInfo.username).getDocuments { snapshot, error in
                                    if error != nil {
                                        self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription)
                                        
                                    }else{
                                        
                                        if snapshot?.isEmpty == false && snapshot != nil {
                                            for document in snapshot!.documents{
                                                
                                                let documentId = document.documentID
                                
                                let chancingDictionary2 = ["postedBy" : self.usernameText.text]
                                
                                firestore.collection("Posts").document(documentId).updateData(chancingDictionary2) { error in
                                    if error != nil {
                                        
                                        self.makeAlert(titleInput: "Error!", messageInput: error!.localizedDescription ?? "Error!")
                                    }else{
                                        
                                        self.tabBarController?.selectedIndex = 3
                                        self.profileImage.image = UIImage(named: "plus")
                                    }
                                }
                            }
        }
        
    }
    
                }
            }
        }
    }
    
                }}}}
    
    
    
    func makeAlert(titleInput : String, messageInput : String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK!", style: UIAlertAction.Style.default)
        alert.addAction(okButton)
        self.present(alert, animated: true)

    }
    
    
    
    
    
    
}
