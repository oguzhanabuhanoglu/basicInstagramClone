//
//  profileSettingsViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 14.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore

class userInfoVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var usernameText: UITextField!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        usernameText.backgroundColor = .secondarySystemBackground
        usernameText.textColor = .label
        
        continueButton.backgroundColor = .systemBackground
        continueButton.tintColor = .tintColor
        
        profileImage.layer.masksToBounds = true
        profileImage.isUserInteractionEnabled = true
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(selectImages2))
        profileImage.addGestureRecognizer(gestureRecognizer2)
        
    }
    
    
    
    func makeAlert(tittleInput: String , messageInput: String){
           
           let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
           let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(okButton)
           present(alert, animated: true, completion: nil)
       }
    
    
    @objc func selectImages2() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        profileImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    @IBAction func continueButton(_ sender: Any) {
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("profileImages")
        
        if let data = profileImage.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    
                    self.makeAlert(tittleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                    
                }else {
                    
                    imageRef.downloadURL { [self] (url, error) in
                        
                        if error == nil{
                            
                            let profileImageUrl = url?.absoluteString
                            
                            //DATABASE CLOUDFİRESTORE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreRefence : DocumentReference? = nil
                            
                            
                            let userProfile = ["username" : self.usernameText.text! , "profileImageUrl" : profileImageUrl, "email" : Auth.auth().currentUser!.email!] as [String : Any]
                            
                            
                            firestoreRefence = firestoreDatabase.collection("Profile").addDocument(data: userProfile, completion: { error in
                                
                                
                                if error != nil {
                                    
                                    self.makeAlert(tittleInput: "ERROR", messageInput: error?.localizedDescription ?? "ERROR")
                                    
                                }else{
                                    
                                    self.profileImage.image = UIImage(named: "plusImage")
                                    self.usernameText.text = ""
                                    self.performSegue(withIdentifier: "toTabBar", sender: nil)
                                    self.tabBarController?.selectedIndex = 4
                                    
                                }
                            })
    }
  }
                }
            }
        }
    }
    
    
    
    
    
    
}
