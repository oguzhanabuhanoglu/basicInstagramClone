//
//  ProfileViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 7.11.2022.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import SDWebImage

class profileVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    @IBOutlet weak var userProfileImage: UIImageView!
    @IBOutlet weak var postNumberLabel: UILabel!
    @IBOutlet weak var followedNumber: UILabel!
    @IBOutlet weak var followerNumber: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    
    
    var imageUrlArray = [String]()
    var profileImageUrlArray = [String]()
    var usernameArray = [String]()
    var collectionArray = [Collection]()
    
    var chosenPost : Collection?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.edit, target: self, action: #selector(profileEdit))
        
       
        
        
        userProfileImage.layer.masksToBounds = true
        userProfileImage.layer.cornerRadius = userProfileImage.frame.height / 2
        userProfileImage.clipsToBounds = true
        
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 120)
        collectionView.collectionViewLayout = layout
        layout.minimumLineSpacing = 3
        layout.minimumInteritemSpacing = 0
       
        
        
        collectionView.register(ProfileCell.nib(), forCellWithReuseIdentifier: ProfileCell.identifier)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
    
        
        userProfileImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        userProfileImage.addGestureRecognizer(gestureRecognizer)
        
        getDataForProfile()
        getDataForProfileCollection()
        //additionalInfoForProfile()
        
        
    }
    
  /*  func additionalInfoForProfile(){
        
        let fd = Firestore.firestore()
        
        var firestoreReference : DocumentReference? = nil
        
        let userProfile = ["postNumber" : postNumberLabel.text, "follower" : followerNumber.text, "followed" : followedNumber.text, "collectionView" : imageUrlArray] as [String : Any]
        
      
        
    }*/
    
    
    /*func getDataFromUserInfo(){
        
        firestoreDatabase.collection("userInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(title: "Error", message: error?.localizedDescription ?? "Error")
            }else{
                
                if snapshot?.isEmpty == false && snapshot != nil {
                    for document in snapshot!.documents{
                        if let username = document.get("username") as? String {
                            
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = username
                        
                        }
                    }
                }
            }
        }
    }*/
    
    
    @objc func profileEdit(){
        performSegue(withIdentifier: "toProfileEdit", sender: nil)
    }
    
    
    @objc func selectImage(){
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true, completion: nil)
        
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        
        self.userProfileImage.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true, completion: nil)
        
       
    }
        
    
    
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileCell.identifier, for: indexPath) as! ProfileCell
        cell.imageView.sd_setImage(with: URL(string: self.collectionArray[indexPath.row].imageUrl))
        cell.imageView.contentMode = .scaleAspectFit
        return cell
        
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionArray.count
    }

    
    /*override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! postVC
        destinationVC.selectedPost = chosenPost
    }
    
    
   
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        chosenPost = collectionArray[indexPath.row]
        performSegue(withIdentifier: "toPostVC", sender: nil)
    }*/
    
    
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 90, height: 90)
    }
    
    
    
    
    
    func getDataForProfileCollection(){
        
        let firestoreDatabase = Firestore.firestore()
        
        firestoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            
            if error != nil {
                
                print(error?.localizedDescription)
            }else{
                
                self.collectionArray.removeAll(keepingCapacity: false)
                
                if snapshot?.isEmpty != true{
        
                    
                    for document in snapshot!.documents {
                        
                        
                        
                        if let postedBy = document.get("postedBy") as? String{
                            
                            if postedBy == UserSingleton.sharedUserInfo.username {
                                
                                if let imageUrl = document.get("imageUrl") as? String{
                                    self.imageUrlArray.append(imageUrl)
                                    if let postComment = document.get("postComment") as? String{
                                        
                                        let collection = Collection(imageUrl: imageUrl, postedBy: postedBy, postComment: postComment)
                                        self.collectionArray.append(collection)
                                        self.postNumberLabel.text = String(self.collectionArray.count)
                                    }
        
                                    //print(self.imageUrlArray.count)
                                }
                            }
                        }
                    }
                    self.collectionView.reloadData()
                }
            }
        }
      }
    
    
    
   /* func getAllProfileInfo() {
        
        
        let fd = Firestore.firestore()
        
        fd.collection("Profile").getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(tittleInput: "error", messageInput: error!.localizedDescription)
            }else{
                
                if snapshot?.isEmpty == false && snapshot != nil {

                    for document in snapshot!.documents{
                        
                        if let username = document.get("username") as? String {
                            if let profileImageUrl = document.get("profileImageUrl") as? String{
                                
                               // let profileInfo = searchingProfileInfo(username: username, userProfileImage: profileImageUrl, postNumber: <#T##String#>, follower: <#T##String#>, followed: <#T##String#>, collectionView: <#T##[String]#>)
                                

                                
                            
                    }
            }
        }
        
        
            }
            }
    }
        
    }*/
    
    
    
    
    
    func getDataForProfile() {
        
        let firestoreDatabase = Firestore.firestore()
                
        firestoreDatabase.collection("Profile").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            
            if error != nil{
                
                print(error?.localizedDescription)
            }else{
                
                if snapshot?.isEmpty != true {
                    for document in snapshot!.documents{
                            
                            if let username = document.get("username") as? String {
                                self.navigationItem.title = username
        
                            
                            if let profileImageURL = document.get("profileImageUrl") as? String{
                                self.userProfileImage.sd_setImage(with: URL(string: profileImageURL))
                            }else{
                                self.userProfileImage.image = UIImage(named: "plusImage")
                            }
            
                    }
                
                }
                    self.userProfileImage.reloadInputViews()
                   
                    
        }
    }
}
}
    
    
    func makeAlert(tittleInput : String, messageInput : String) {
        
        let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    
    
    
    
    
}
                    
    
