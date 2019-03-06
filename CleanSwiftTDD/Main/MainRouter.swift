//
//  MainRouter.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import UIKit

protocol MainRoutingLogic {
    func routeToNext()
    func routeToLogOut()
}

protocol MainDataPassing {
    var dataStore: MainDataStore? { get }
}

class MainRouter: NSObject, MainRoutingLogic, MainDataPassing {
    var viewController: MainViewController?
    var dataStore: MainDataStore?

    // MARK: - Routing
    
    func routeToLogOut() {
        
    }

    func routeToNext() {
        // let destinationVC = UIStoryboard(name: "", bundle: nil).instantiateViewController(withIdentifier: "") as! NextViewController
        // var destinationDS = destinationVC.router!.dataStore!
        // passDataTo(destinationDS, from: dataStore!)
        // viewController?.navigationController?.pushViewController(destinationVC, animated: true)
    }

    // MARK: - Data Passing

    // func passDataTo(_ destinationDS: inout NextDataStore, from sourceDS: MainDataStore) {
    //     destinationDS.attribute = sourceDS.attribute
    // }
}
