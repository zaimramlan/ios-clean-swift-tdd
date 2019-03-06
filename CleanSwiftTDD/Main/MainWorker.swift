//
//  MainWorker.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import UIKit

class MainWorker {
    
    // MARK: - Properties
    
    let userSessionStatusKey = "isLoggedIn"
    
    // MARK: - Use Cases
    
    func fetchUserData(completion: @escaping (_ name: String?, _ email: String?) -> Void) {
        APIWorker().fetchUserData { (response) in
            completion(response?.name, response?.email)
        }
    }
    
    func performLogOut() {
        UserDefaults.standard.set(false, forKey: userSessionStatusKey)
    }
}
