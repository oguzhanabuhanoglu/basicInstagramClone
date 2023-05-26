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
    
    private let profileImage : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(systemName: "plus.circle")
        imageView.tintColor = .label
        imageView.backgroundColor = .systemBackground
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.secondarySystemBackground.cgColor
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let usernameText : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Username"
        textfield.backgroundColor = .secondarySystemBackground
        textfield.textColor = .label
        textfield.layer.cornerRadius = 10
        return textfield
    }()
    
    private let biografiText : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Biografi"
        textfield.backgroundColor = .secondarySystemBackground
        textfield.textColor = .label
        textfield.layer.cornerRadius = 10
        return textfield
    }()
    
    private let continueButton : UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: UIControl.State.normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(UIColor.label, for: UIControl.State.normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Create your profile"
        
        view.addSubview(profileImage)
        view.addSubview(usernameText)
        view.addSubview(continueButton)
        view.addSubview(biografiText)
        
        
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(selectImages2))
        profileImage.addGestureRecognizer(gestureRecognizer2)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let widht = view.frame.size.width
        let height = view.frame.size.height
        
        profileImage.frame = CGRect(x: widht * 0.5 - 160/2, y: height * 0.29 - 160 / 2, width: 150, height: 150)
        profileImage.layer.cornerRadius = profileImage.frame.width / 2
        
        usernameText.frame = CGRect(x: widht * 0.5 - widht * 0.4, y: height * 0.43 - 40/2, width: widht * 0.8, height: 40)
        
        biografiText.frame = CGRect(x: widht * 0.5 - widht * 0.4, y: height * 0.50 - 40/2, width: widht * 0.8, height: 40)
        
        continueButton.frame = CGRect(x: widht * 0.5 - widht * 0.45, y: height * 0.60 - 40/2, width: widht * 0.9, height: 40)
        continueButton.addTarget(self, action: #selector(continueButtonClicked), for: UIControl.Event.touchUpInside)
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
    
    
    
    @objc func continueButtonClicked() {
        
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
                            
                            
                            let userProfile = ["username" : self.usernameText.text! , "profileImageUrl" : profileImageUrl, "biografi" : self.biografiText.text!, "email" : Auth.auth().currentUser!.email!] as [String : Any]
                            
                            
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
