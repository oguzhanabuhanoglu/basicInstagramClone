//
//  UpdateViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 8.09.2022.
//

import UIKit
import FirebaseCore
import FirebaseStorage
import FirebaseFirestore
import FirebaseAuth
import FirebaseAnalytics


class sharePostVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private let postImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.image = UIImage(named: "newPost")
        imageView.tintColor = .label
        imageView.backgroundColor = .systemBackground
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let commentText : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Comment..."
        textfield.backgroundColor = .secondarySystemBackground
        textfield.textColor = .label
        textfield.layer.cornerRadius = 10
        return textfield
    }()
    
    private let uploadButton : UIButton = {
        let button = UIButton()
        button.setTitle("Upload", for: UIControl.State.normal)
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

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        navigationItem.title = "Instagram"
    
        view.addSubview(postImageView)
        view.addSubview(commentText)
        view.addSubview(uploadButton)
        
        postImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImages))
        postImageView.addGestureRecognizer(gestureRecognizer)
        
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        let widht = view.frame.size.width
        let height = view.frame.size.height
        
        postImageView.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2 , y: height * 0.33 - (height * 0.4)/2 , width: widht * 0.9, height: height * 0.4)
        
        commentText.frame = CGRect(x: widht * 0.5 - (widht * 0.9) / 2, y: height * 0.57 - 50/2, width: widht * 0.9, height: 50)
        
        uploadButton.frame = CGRect(x: widht * 0.5 - (widht * 0.8) / 2, y: height * 0.7 - 35/2, width: widht * 0.8, height: 35)
        uploadButton.addTarget(self, action: #selector(updateClicked), for: UIControl.Event.touchUpInside)
        
    }
    
    
    @objc func selectImages() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        postImageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func makeAlert(tittleInput: String , messageInput: String){
           
           let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
           let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(okButton)
           present(alert, animated: true, completion: nil)
       }
    

    @objc func updateClicked() {
        

        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = postImageView.image?.jpegData(compressionQuality: 0.5) {
            
            let uuid = UUID().uuidString
            
            let imageRef = mediaFolder.child("\(uuid).jpg")
            imageRef.putData(data, metadata: nil) { (metadata, error) in
                
                if error != nil {
                    
                    self.makeAlert(tittleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                    
                }else {
                    
                    imageRef.downloadURL { (url, error) in
                        
                        if error == nil{
                            
                            let imageUrl = url?.absoluteString
                            
                            
                            //DATABASE CLOUDFİRESTORE
                            
                            let firestoreDatabase = Firestore.firestore()
                            
                            var firestoreReference : DocumentReference? = nil
                          
                            let firestorePost = ["imageUrl" : imageUrl!, "postedBy" : UserSingleton.sharedUserInfo.username, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "like" : 0] as [String : Any]
                            
                            firestoreReference = firestoreDatabase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                
                                if error != nil {
                                    
                                    self.makeAlert(tittleInput: "Error!", messageInput: error?.localizedDescription ?? "Error")
                               
                                }else {
                                    
                                    self.postImageView.image = UIImage(named: "newPost")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    
                                }
                        })
                        }
                    }
                    
                }
            }
        }
}
    
    
    
    
    
}
    



