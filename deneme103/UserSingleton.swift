//
//  UserSingleton.swift
//  deneme103
//
//  Created by Oğuzhan Abuhanoğlu on 29.12.2022.
//

import Foundation

class UserSingleton {
    
    static let sharedUserInfo = UserSingleton()
    
    var email = ""
    var username = ""
    
    private init(){
        
    }
}
