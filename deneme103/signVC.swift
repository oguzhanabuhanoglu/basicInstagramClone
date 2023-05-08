//
//  ViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 8.09.2022.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class signVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Instagram"
        view.backgroundColor = .systemBackground
        
        emailText.backgroundColor = .secondarySystemBackground
        emailText.textColor = .label
        
        passwordText.backgroundColor = .secondarySystemBackground
        passwordText.textColor = .label
        
        signInButton.backgroundColor = .systemBackground
        signInButton.titleLabel?.tintColor = .tintColor
        
        logInButton.backgroundColor = .systemBackground
        logInButton.titleLabel?.tintColor = .tintColor
        
    }
    
    
    @IBAction func signInClicked(_ sender: Any) {
        
        if emailText.text != "" && passwordText.text != "" {
                   
                   Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                       
                       if error != nil {
                           
                           self.makeAlert(tittleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                         
                       }else{
                           
                          
                           self.performSegue(withIdentifier: "toProfileSettingsVC", sender: nil)
                           
                           
                       }
                   }

               } else {
                   
                   self.makeAlert(tittleInput: "Error!", messageInput: "email/password?")
                  

    }
    }
    
    //self.performSegue(withIdentifier: "toProfileSettingsVC", sender: nil)
    
    @IBAction func logInClicked(_ sender: Any) {
        
        
        if emailText.text != "" && passwordText.text != "" {
                    
                    Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                        
                        if error != nil {
                            
                            self.makeAlert(tittleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")

                        }else {
                            
                            
                            self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                            
                        }
                }
                }else {
                    
                    self.makeAlert(tittleInput: "Error!", messageInput: "username/password?")
                }

    }
    
        
        
        func makeAlert(tittleInput: String , messageInput: String){
               
               let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
               let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
               alert.addAction(okButton)
               present(alert, animated: true, completion: nil)
           }
    

}


