//
//  searchViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 15.11.2022.
//

import UIKit
import FirebaseFirestore
import FirebaseCore


class searchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    @IBOutlet weak var seachText: UITextField!
    @IBOutlet weak var resultTableView: UITableView!
    
    var data = [String]()
    var filteredData = [String]()
    var filtered = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resultTableView.delegate = self
        resultTableView.dataSource = self
        seachText.delegate = self
        
        getDataForSearch()
       
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let text = textField.text{
            filterText(text+string)
        }
        
        return true
    }
    
    
    
    func filterText(_ query : String?){
        
        filteredData.removeAll()
        for string in data{
            if string.lowercased().starts(with: (query?.lowercased())!){
                filteredData.append(string)
          }
       }
        resultTableView.reloadData()
        filtered = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if filteredData.isEmpty == false {
            return filteredData.count
        }
        return filtered ? 0 : data.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = resultTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if filteredData.isEmpty == false {
            cell.textLabel?.text = filteredData[indexPath.row]
        }else{
            cell.textLabel?.text = data[indexPath.row]
        }
        return cell
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
   
    
    func getDataForSearch(){
        
        let fd = Firestore.firestore()
        
        fd.collection("Profile").getDocuments { snapshot, error in
            
            if error != nil {
                print(error?.localizedDescription)
            }else{
                
                if snapshot?.isEmpty != true{
                    
                    for document in snapshot!.documents{
                        
                        if let username = document.get("username") as? String {
                            self.data.append(username)
                            
                            print(self.data)
                            
                        }
                        
                    }
                }
            }
        }
}
    
    
    

    func makeAlert(tittleInput : String, messageInput : String) {
        
        let alert = UIAlertController(title: tittleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okButton)
        present(alert, animated: true, completion: nil)
    }

        

  

}
