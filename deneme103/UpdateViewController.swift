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


class UpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        imageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImages))
        imageView.addGestureRecognizer(gestureRecognizer)
        
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = imageView.frame.width / 2
        
        navigationItem.title = "Instagram"
    }
    
    
    @objc func selectImages() {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    
    func makeAlert(tittleInput: String , messageInput: String){
           
           let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
           let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
           alert.addAction(okButton)
           present(alert, animated: true, completion: nil)
       }
    

    @IBAction func updateClicked(_ sender: Any) {
        
        
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        
        let mediaFolder = storageRef.child("media")
        
        if let data = imageView.image?.jpegData(compressionQuality: 0.5) {
            
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
                                    
                                    self.imageView.image = UIImage(named: "plusImage")
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
    



