//
//  MainViewControllerSpec.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import Quick
import Nimble
@testable import CleanSwiftTDD

class MainViewControllerSpec: QuickSpec {
    override func spec() {
        
        // MARK: - Subject Under Test (SUT)
        
        var sut: MainViewController!
        var window: UIWindow!
        
        // MARK: - Test Doubles
        
        var businessLogicSpy: MainBusinessLogicSpy!
        var routerSpy: MainRouterSpy!
        
        // MARK: - Tests
        
        beforeEach {
            window = UIWindow()
            setupInitialUserState()
            setupViewController()
            setupBusinessLogic()
            setupRouter()
        }
        
        afterEach {
            window = nil
        }
        
        // MARK: View Lifecycle

        describe("view did load") {
        }

        describe("view will appear") {
            it("should fetch from data store", closure: {
                // given

                // when
                loadView()
                sut.viewWillAppear(true)
                
                // then
                expect(businessLogicSpy.fetchFromDataStoreCalled).to(beTrue())
            })
            
            it("should track analytics", closure: {
                // given
                loadView()
                
                // when
                sut.viewWillAppear(true)

                // then
                expect(businessLogicSpy.trackAnalyticsCalled).to(beTrue())
            })
        }
        
        // MARK: IBActions/Delegates
        
        describe("bar button item") {
            it("should ask interactor to log out", closure: {
                // given
                loadView()
                
                // when
                let selector = sut.barButtonItem?.action
                sut.barButtonItem!.perform(selector!, with: nil, afterDelay: 1)

                // then
                expect(businessLogicSpy.logOutCalled).toEventually(beTrue())
            })
        }
        
        // MARK: Display Logic
        
        describe("display fetch from data store") {
            beforeEach {
                // given
                loadView()
                let viewModel = MainModels.FetchFromDataStore.ViewModel(name: Seeds.name, email: Seeds.email)
                
                // when
                sut.displayFetchFromDataStore(with: viewModel)
            }
            
            it("should display the fetched user name", closure: {
                // then
                expect(sut.nameLabel.text).to(equal(Seeds.name))
            })
            
            it("should display the fetched user email", closure: {
                // then
                expect(sut.emailLabel.text).to(equal(Seeds.email))
            })
        }
        
        describe("display log out") {
           it("should ask router to route to log out", closure: {
                // given
                loadView()
                
                // when
                let viewModel = MainModels.LogOut.ViewModel()
                sut.displayLogOut(with: viewModel)
                
                // then
                expect(routerSpy.routeToLogOutCalled).to(beTrue())
            })
        }

        describe("display track analytics") {
            it("should display fetch from datastore", closure: {
                // given
                loadView()

                // when
                let viewModel = MainModels.TrackAnalytics.ViewModel()
                sut.displayTrackAnalytics(with: viewModel)            

                // then
                // assert something here based on use case
            })
        }

        describe("display perform Main") {
            it("should route to next", closure: {
                // given
                loadView()
                
                // when
                let viewModel = MainModels.PerformMain.ViewModel()
                sut.displayPerformMain(with: viewModel)

                // then
                expect(routerSpy.routeToNextCalled).to(beTrue())
            })            
        }
        
        // MARK: - Test Helpers
        
        func setupInitialUserState() {
            // some initial user state setup
        }
        
        func setupViewController() {
            let bundle = Bundle.main
            let storyboard = UIStoryboard(name: "Main", bundle: bundle)
            sut = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController
        }
        
        func setupBusinessLogic() {
            businessLogicSpy = MainBusinessLogicSpy()
            sut.interactor = businessLogicSpy
        }
        
        func setupRouter() {
            routerSpy = MainRouterSpy()
            sut.router = routerSpy
        }
        
        func loadView() {
            window.addSubview(sut.view)
            RunLoop.current.run(until: Date())
        }
    }
}

// MARK: - Test Doubles

extension MainViewControllerSpec {
    class MainBusinessLogicSpy: MainBusinessLogic {

        // MARK: Spied Methods
        
        var fetchFromDataStoreCalled = false
        func fetchFromDataStore(with request: MainModels.FetchFromDataStore.Request) {
            fetchFromDataStoreCalled = true
        }

        var trackAnalyticsCalled = false
        func trackAnalytics(with request: MainModels.TrackAnalytics.Request) {
            trackAnalyticsCalled = true
        }

        var performMainCalled = false
        func performMain(with request: MainModels.PerformMain.Request) {
            performMainCalled = true
        }
        
        var logOutCalled = true
        func logOut(with request: MainModels.LogOut.Request) {
            logOutCalled = true
        }
    }
    
    class MainRouterSpy: MainRouter {
        
        // MARK: Spied Methods
        
        var routeToNextCalled = false
        override func routeToNext() {
            routeToNextCalled = true
        }
        
        var routeToLogOutCalled = false
        override func routeToLogOut() {
            routeToLogOutCalled = true
        }
    }
}
