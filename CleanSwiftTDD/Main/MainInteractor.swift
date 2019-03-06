//
//  MainInteractor.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import UIKit

protocol MainBusinessLogic {
    func fetchFromDataStore(with request: MainModels.FetchFromDataStore.Request)
    func logOut(with request: MainModels.LogOut.Request)
    func trackAnalytics(with request: MainModels.TrackAnalytics.Request)
    func performMain(with request: MainModels.PerformMain.Request)
}

protocol MainDataStore {
}

class MainInteractor: MainBusinessLogic, MainDataStore {
    var worker: MainWorker? = MainWorker()
    var presenter: MainPresentationLogic?
    
    // MARK: Use Case - Fetch From Data Store
    
    func fetchFromDataStore(with request: MainModels.FetchFromDataStore.Request) {
        worker?.fetchUserData(completion: {
            [weak self] (name, email) in
            if let name = name, let email = email {
                let response = MainModels.FetchFromDataStore.Response(name: name, email: email)
                self?.presenter?.presentFetchFromDataStore(with: response)
            }
        })
    }
    
    // MARK: Use Case - Log Out
    
    func logOut(with request: MainModels.LogOut.Request) {
        worker?.performLogOut()
        
        let decimal = Decimal.init(string: request.amount) ?? 0
        let response = MainModels.LogOut.Response.init(amount: decimal)
        presenter?.presentLogOut(with: response)
    }

    // MARK: Use Case - Track Analytics

    func trackAnalytics(with request: MainModels.TrackAnalytics.Request) {
        // call analytics library/wrapper here to track analytics
        let response = MainModels.TrackAnalytics.Response()
        presenter?.presentTrackAnalytics(with: response)
    }

    // MARK: Use Case - Main

    func performMain(with request: MainModels.PerformMain.Request) {
        let response = MainModels.PerformMain.Response()
        presenter?.presentPerformMain(with: response)
    }
}
