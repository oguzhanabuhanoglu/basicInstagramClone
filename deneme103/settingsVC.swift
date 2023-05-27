//
//  SettingsViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 8.09.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore

struct settingsCellModel {
    let title : String
    let handler : (() -> Void)
}

class settingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let tableView : UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    private var data = [[settingsCellModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Settings"
        view.backgroundColor = .systemBackground
        
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        configureModels()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
    }
    
    private func configureModels(){
        
        data.append([
            settingsCellModel(title: "Terms Of Service") { [weak self] in
            
           },
            settingsCellModel(title: "Privacy Policy") { [weak self] in
            
           },
            settingsCellModel(title: "Help / Feedback") { [weak self] in
            
           }
        ])
        
        
        data.append([
            settingsCellModel(title: "Edit Profile ") { [weak self] in
                self?.tapEditProfile()
           }
        ])
        
        
        data.append([
            settingsCellModel(title: "Log Out") { [weak self] in
            self?.didTapLogOut()
           }
        ])
        
        
        
        
        
    }
    
    @objc func toBack() {
        self.dismiss(animated: true)
    }
    
    private func didTapLogOut() {
        
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "logOut", sender: nil)
        } catch{
            print("error")
        }
        
    }
    
    private func tapEditProfile(){

        
        let vc = profileEditVC()
            vc.title = "Edit Profile"
            vc.navigationItem.largeTitleDisplayMode = .never
            
            let navController = UINavigationController(rootViewController: vc)
            navController.modalPresentationStyle = .automatic
            navController.navigationBar.titleTextAttributes = [
                NSAttributedString.Key.font: UIFont(name: "AvenirNext-Heavy", size: 30),
                NSAttributedString.Key.foregroundColor: UIColor.label // Metin rengi ayarı
            ]
            present(navController, animated: true, completion: nil)
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.section][indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        data[indexPath.section][indexPath.row].handler()
    }
    


}
