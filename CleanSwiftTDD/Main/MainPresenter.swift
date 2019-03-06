//
//  MainPresenter.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import UIKit

protocol MainPresentationLogic {
    func presentFetchFromDataStore(with response: MainModels.FetchFromDataStore.Response)
    func presentLogOut(with response: MainModels.LogOut.Response)
    func presentTrackAnalytics(with response: MainModels.TrackAnalytics.Response)
    func presentPerformMain(with response: MainModels.PerformMain.Response)
}

class MainPresenter: MainPresentationLogic {
    weak var viewController: MainDisplayLogic?
    
    // MARK: Use Case - Fetch From Data Store
    
    func presentFetchFromDataStore(with response: MainModels.FetchFromDataStore.Response) {
        let viewModel = MainModels.FetchFromDataStore.ViewModel(name: response.name, email: response.email)
        viewController?.displayFetchFromDataStore(with: viewModel)
    }
    
    // MARK: Use Case - Log Out
    
    func presentLogOut(with response: MainModels.LogOut.Response) {
        let viewModel = MainModels.LogOut.ViewModel()
        viewController?.displayLogOut(with: viewModel)
    }

    // MARK: Use Case - Track Analytics

    func presentTrackAnalytics(with response: MainModels.TrackAnalytics.Response) {
        let viewModel = MainModels.TrackAnalytics.ViewModel()
        viewController?.displayTrackAnalytics(with: viewModel)
    }

    // MARK: Use Case - Main

    func presentPerformMain(with response: MainModels.PerformMain.Response) {
        let viewModel = MainModels.PerformMain.ViewModel()
        viewController?.displayPerformMain(with: viewModel)
    }
}
