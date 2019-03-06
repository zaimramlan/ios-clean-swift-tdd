//
//  MainPresenterSpec.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import Quick
import Nimble
@testable import CleanSwiftTDD

class MainPresenterSpec: QuickSpec {
    override func spec() {
        
        // MARK: - Subject Under Test (SUT)
        
        var sut: MainPresenter!
        
        // MARK: - Test Doubles
        
        var displayLogicSpy: MainDisplayLogicSpy!
        
        // MARK: - Tests
        
        beforeEach {
            setupInitialUserState()
            setupPresenter()
            setupDisplayLogic()
        }
        
        afterEach {
            sut = nil
        }
        
        // MARK: Use Cases
        
        describe("present fetch from data store") {
            it("should ask view controller to display", closure: {
                // given
                let response = MainModels.FetchFromDataStore.Response(name: Seeds.name, email: Seeds.email)
                
                // when
                sut.presentFetchFromDataStore(with: response)
                
                // then
                expect(displayLogicSpy.displayFetchFromDataStoreCalled).to(beTrue())
                expect(displayLogicSpy.displayFetchFromDataStoreViewModel?.name).to(equal(Seeds.name))
                expect(displayLogicSpy.displayFetchFromDataStoreViewModel?.email).to(equal(Seeds.email))
            })
        }
        
        describe("present log out") {
            it("should ask view controller to display", closure: {
                // given
                let dummy = Decimal(0)
                let response = MainModels.LogOut.Response.init(amount: dummy)
                
                // when
                sut.presentLogOut(with: response)
                
                // then
                expect(displayLogicSpy.displayLogOutCalled).to(beTrue())
            })
        }

        describe("present track analytics") {
            it("should ask view controller to display", closure: {
                // given
                let response = MainModels.TrackAnalytics.Response()

                // when
                sut.presentTrackAnalytics(with: response)

                // then
                expect(displayLogicSpy.displayTrackAnalyticsCalled).to(beTrue())
            })
        }

        describe("present perform Main") {
            it("should ask view controller to display", closure: {
                // given
                let response = MainModels.PerformMain.Response()

                // when
                sut.presentPerformMain(with: response)

                // then
                expect(displayLogicSpy.displayPerformMainCalled).to(beTrue())
            })
        }
        
        // MARK: - Test Helpers
        
        func setupInitialUserState() {
            // some initial user state setup
        }
        
        func setupPresenter() {
            sut = MainPresenter()
        }
        
        func setupDisplayLogic() {
            displayLogicSpy = MainDisplayLogicSpy()
            sut.viewController = displayLogicSpy
        }
    }
}

// MARK: - Test Doubles

extension MainPresenterSpec {
    class MainDisplayLogicSpy: MainDisplayLogic {

        // MARK: Spied Methods
        
        var displayFetchFromDataStoreCalled = false
        var displayFetchFromDataStoreViewModel: MainModels.FetchFromDataStore.ViewModel?
        func displayFetchFromDataStore(with viewModel: MainModels.FetchFromDataStore.ViewModel) {
            displayFetchFromDataStoreCalled = true
            displayFetchFromDataStoreViewModel = viewModel
        }

        var displayTrackAnalyticsCalled = false
        func displayTrackAnalytics(with viewModel: MainModels.TrackAnalytics.ViewModel) {
            displayTrackAnalyticsCalled = true
        }

        var displayPerformMainCalled = false
        func displayPerformMain(with viewModel: MainModels.PerformMain.ViewModel) {
            displayPerformMainCalled = true
        }
        
        var displayLogOutCalled = false
        func displayLogOut(with viewModel: MainModels.LogOut.ViewModel) {
            displayLogOutCalled = true
        }
    }
}
