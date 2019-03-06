//
//  MainInteractorSpec.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import Quick
import Nimble
import Mockingjay
@testable import CleanSwiftTDD

class MainInteractorSpec: QuickSpec {
    override func spec() {
        
        // MARK: - Subject Under Test (SUT)
        
        var sut: MainInteractor!
        
        // MARK: - Test Doubles
        
        var presentationLogicSpy: MainPresentationLogicSpy!
        var workerSpy: MainWorkerSpy!
        var networkStub: Stub!
        
        // MARK: - Tests
        
        beforeEach {
            setupInitialUserState()
            setupInteractor()
            setupPresentationLogic()
            setupWorker()
        }
        
        afterEach {
            removeNetworkStub()
            sut = nil
        }

        // MARK: Use Cases
        
        describe("fetch from data store") {
            beforeEach {
                // given
                stubNetwork(as: ["name": Seeds.name, "email": Seeds.email])
                let request = MainModels.FetchFromDataStore.Request()
                
                // when
                sut.fetchFromDataStore(with: request)
            }
            
            it("should ask worker to fetch user data", closure: {
                // then
                expect(workerSpy.fetchUserDataCalled).to(beTrue())
            })
            
            it("should ask presenter to present fetched user data", closure: {
                // then
                expect(presentationLogicSpy.presentFetchFromDataStoreCalled).toEventually(beTrue())
                expect(presentationLogicSpy.presentFetchFromDataStoreResponse?.name).toEventually(equal(Seeds.name))
                expect(presentationLogicSpy.presentFetchFromDataStoreResponse?.email).toEventually(equal(Seeds.email))
            })
        }
        
        describe("log out") {
            let amount = "999"
            let expectedAmount = Decimal.init(string: amount)! // 999 in decimals
            
            beforeEach {
                // given
                let request = MainModels.LogOut.Request.init(amount: amount)
                
                // when
                sut.logOut(with: request)
            }
            
            it("should ask worker to perform log out", closure: {
                // then
                expect(workerSpy.performLogOutCalled).to(beTrue())
            })
            
            it("should ask presenter to present log out", closure: {
                // then
                expect(presentationLogicSpy.presentLogOutCalled).to(beTrue())
                expect(presentationLogicSpy.presentLogOutResponse.amount).to(equal(expectedAmount))
            })
        }
        
        describe("track analytics") {
            it("should ask presenter to format", closure: {
                // given
                let request = MainModels.TrackAnalytics.Request()

                // when
                sut.trackAnalytics(with: request)

                // then
                expect(presentationLogicSpy.presentTrackAnalyticsCalled).to(beTrue())
            })
        }
        
        describe("perform Main") {
            it("should ask presenter to format", closure: {
                // given
                let request = MainModels.PerformMain.Request()

                // when
                sut.performMain(with: request)

                // then
                expect(presentationLogicSpy.presentPerformMainCalled).to(beTrue())                
            })            
        }

        // MARK: - Test Helpers
        
        func setupInitialUserState() {
            // some initial user state setup
        }
        
        func setupInteractor() {
            sut = MainInteractor()
        }
        
        func setupPresentationLogic() {
            presentationLogicSpy = MainPresentationLogicSpy()
            sut.presenter = presentationLogicSpy
        }
        
        func setupWorker() {
            workerSpy = MainWorkerSpy()
            sut.worker = workerSpy
        }
        
        func stubNetwork(as response: [String: String] = [:], status: Int = 200) {
            networkStub = stub(everything, json(response, status: status))
        }
        
        func removeNetworkStub() {
            if let stub = networkStub {
                removeStub(stub)
                networkStub = nil
            }
        }
    }
}

// MARK: - Test Doubles

extension MainInteractorSpec {
    class MainPresentationLogicSpy: MainPresentationLogic {

        // MARK: Spied Methods
        
        var presentFetchFromDataStoreCalled = false
        var presentFetchFromDataStoreResponse: MainModels.FetchFromDataStore.Response?
        func presentFetchFromDataStore(with response: MainModels.FetchFromDataStore.Response) {
            presentFetchFromDataStoreCalled = true
            presentFetchFromDataStoreResponse = response
        }

        var presentTrackAnalyticsCalled = false
        func presentTrackAnalytics(with response: MainModels.TrackAnalytics.Response) {
            presentTrackAnalyticsCalled = true
        }

        var presentPerformMainCalled = false
        func presentPerformMain(with response: MainModels.PerformMain.Response) {
            presentPerformMainCalled = true
        }
        
        var presentLogOutCalled = false
        var presentLogOutResponse = MainModels.LogOut.Response.init(amount: 0)
        func presentLogOut(with response: MainModels.LogOut.Response) {
            presentLogOutCalled = true
            presentLogOutResponse = response
        }
    }
    
    class MainWorkerSpy: MainWorker {
        
        // MARK: Spied Methods

        var fetchUserDataCalled = false
        var fetchedName: String?
        var fetchedEmail: String?
        override func fetchUserData(completion: @escaping (String?, String?) -> Void) {
            fetchUserDataCalled = true
            
            super.fetchUserData {
                [weak self] (name, email) in
                self?.fetchedName = name
                self?.fetchedEmail = email
                completion(name, email)
            }
        }
        
        var performLogOutCalled = false
        override func performLogOut() {
            performLogOutCalled = true
        }
    }
}
