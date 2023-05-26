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

    private let emailText : UITextField = {
        let textField = UITextField()
        textField.placeholder = "email"
        textField.textAlignment = .left
        textField.backgroundColor = .secondarySystemBackground
        textField.textColor = .label
        return textField
    }()
    
    private let passwordText : UITextField = {
        let textField = UITextField ()
        textField.placeholder = "password"
        textField.textAlignment = .left
        textField.backgroundColor = .secondarySystemBackground
        textField.textColor = .label
        return textField
    }()
    
    private let signInButton : UIButton = {
        let button = UIButton()
        button.setTitle("Sign In", for: UIControl.State.normal)
        button.backgroundColor = .secondarySystemBackground
        button.setTitleColor(UIColor.label, for: UIControl.State.normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 20
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.label.cgColor
        return button
    }()
    
    private let logInButton : UIButton = {
        let button = UIButton()
        button.setTitle("Log In", for: UIControl.State.normal)
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
        navigationItem.title = "Instagram"
        view.backgroundColor = .systemBackground
        
        view.addSubview(emailText)
        view.addSubview(passwordText)
        view.addSubview(signInButton)
        view.addSubview(logInButton)
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let widht = view.frame.size.width
        let height = view.frame.size.height
        

        emailText.frame = CGRect(x: widht * 0.5 - (widht * 0.8) / 2 , y: height * 0.3 - 20, width: widht * 0.8, height: 40)
        
        passwordText.frame = CGRect(x: widht * 0.5 - (widht * 0.8) / 2 , y: height * 0.37 - 20, width: widht * 0.8, height: 40)
        
        signInButton.frame = CGRect(x: widht * 0.25 - (widht * 0.3) / 2, y: height * 0.44 - 20, width: widht * 0.3, height: 40)
        signInButton.addTarget(self, action: #selector(signInClicked), for: UIControl.Event.touchUpInside)
        
        
        logInButton.frame = CGRect(x: widht * 0.75 - (widht * 0.3) / 2, y: height * 0.44 - 20, width: widht * 0.3, height: 40)
        logInButton.addTarget(self, action: #selector(logInClicked), for: .touchUpInside)
       
        
        
    }
    
    
    @objc func signInClicked() {
        
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
    
    @objc func logInClicked() {
        
        
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
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

        
        
        func makeAlert(tittleInput: String , messageInput: String){
               
               let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
               let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
               alert.addAction(okButton)
               present(alert, animated: true, completion: nil)
           }
    

}


