//
//  serachViewController.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 10.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
/Users/oguzhanabuhanoglu/Desktop/l/deneme103/deneme103/FeedViewController.swift
class serachViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let data = [NSDictionary]()
    let filteredData = [NSDictionary]()
    
    
    @IBOutlet weak var searchBar: UITableView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
                
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
        
    }
    
    
    
    
    
    
    

   

}
