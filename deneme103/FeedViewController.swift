//
//  FeedViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 8.09.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseCore
import FirebaseStorage
import SDWebImage


class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
   
   
    let fd = Firestore.firestore()
    
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likeArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    var postArray = [Post]()
    
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        getDataFromPosts()
        getUser()
    }
    
    
    
    func getUser() {
        
        fd.collection("Profile").whereField("email", isEqualTo: Auth.auth().currentUser!.email).getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(tittleInput: "error", messageInput: error!.localizedDescription)
            }else{
                
                if snapshot?.isEmpty == false && snapshot != nil {

                    for document in snapshot!.documents {
                        let documentId = document.documentID
                        
                        if let username = document.get("username") as? String{
                            
                                
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                                UserSingleton.sharedUserInfo.username = username
                                

                            
                        }
                        
                    }
                }
            }
      }
 
  }
    
    
    

    
    func getDataFromPosts(){

        fd.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(tittleInput: "error", messageInput: error!.localizedDescription)
            }else{
                
                if snapshot?.isEmpty == false && snapshot != nil {

                    self.postArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents{
                        let documentId = document.documentID
                        
                        
                        if let userEmail = document.get("postedBy") as? String{
                            if let postUrl = document.get("imageUrl") as? String{
                                if let postComment = document.get("postComment") as? String{
                                    if let date = document.get("date") as? Timestamp{
                                        if let like = document.get("like") as? Int{

                                        
                                            let post = Post(postedBy: userEmail, postComment: postComment, imageUrl: postUrl, date: date.dateValue(), like: like,documentId: documentId)
                                            self.postArray.append(post)
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    self.tableView.reloadData()
                }

                
            }
                
        }
    }
    
    
    
    
    
   
        
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
        
        
        
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath  ) as! feedCell
        cell.userEmailLabel.text = postArray[indexPath.row].postedBy
        cell.commentLabel.text = postArray[indexPath.row].postComment
        cell.userImageView.sd_setImage(with: URL(string: self.postArray[indexPath.row].imageUrl))
        cell.documentIDLabel.text = postArray[indexPath.row].documentId
        return cell
    }
    
    
    func makeAlert(tittleInput : String, messageInput : String) {
        
        let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true, completion: nil)
    }

    
    
    

    
}
