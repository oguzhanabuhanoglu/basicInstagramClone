//
//  SettingsViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 8.09.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore

class settingsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .systemBackground
        
        navigationItem.title = "Instagram"
    }
    

    @IBAction func logOutClicked(_ sender: Any) {
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toViewController", sender: nil)
        } catch{
            print("error")
        }
        
    }
    

}
