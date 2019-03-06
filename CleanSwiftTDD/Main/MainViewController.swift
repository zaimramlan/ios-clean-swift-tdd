//
//  MainViewController.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import UIKit

protocol MainDisplayLogic: class {
    func displayFetchFromDataStore(with viewModel: MainModels.FetchFromDataStore.ViewModel)
    func displayLogOut(with viewModel: MainModels.LogOut.ViewModel)
    func displayTrackAnalytics(with viewModel: MainModels.TrackAnalytics.ViewModel)    
    func displayPerformMain(with viewModel: MainModels.PerformMain.ViewModel)
}

class MainViewController: UIViewController, MainDisplayLogic {

    // MARK: - Properties

    var router: (NSObjectProtocol & MainRoutingLogic & MainDataPassing)?
    var interactor: MainBusinessLogic?

    // MARK: - Object lifecycle

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup

    private func setup() {
        let viewController = self
        let interactor = MainInteractor()
        let presenter = MainPresenter()
        let router = MainRouter()

        viewController.router = router
        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLogOutButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFromDataStore()
        trackAnalytics()
    }
    
    // MARK: Use Case - Fetch From DataStore
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    func fetchFromDataStore() {
        let request = MainModels.FetchFromDataStore.Request()
        interactor?.fetchFromDataStore(with: request)
    }
    
    func displayFetchFromDataStore(with viewModel: MainModels.FetchFromDataStore.ViewModel) {
        nameLabel.text = viewModel.name
        emailLabel.text = viewModel.email
    }
    
    // MARK: Use Case - Log Out
    
    var barButtonItem: UIBarButtonItem?
    func setupLogOutButton() {
        barButtonItem = UIBarButtonItem.init(title: "Log Out", style: .done, target: nil, action: #selector(logOut))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    @objc func logOut() {
        let request = MainModels.LogOut.Request.init(amount: "0")
        interactor?.logOut(with: request)
    }
    
    func displayLogOut(with viewModel: MainModels.LogOut.ViewModel) {
        router?.routeToLogOut()
    }

    // MARK: Use Case - Track Analytics

    func trackAnalytics() {
        let request = MainModels.TrackAnalytics.Request()
        interactor?.trackAnalytics(with: request)
    }

    func displayTrackAnalytics(with viewModel: MainModels.TrackAnalytics.ViewModel) {
        // do something after tracking analytics (if needed)
    }

    // MARK: Use Case - Main

    func performMain(_ sender: Any) {
        let request = MainModels.PerformMain.Request()
        interactor?.performMain(with: request)
    }

    func displayPerformMain(with viewModel: MainModels.PerformMain.ViewModel) {
        router?.routeToNext()
    }
}
