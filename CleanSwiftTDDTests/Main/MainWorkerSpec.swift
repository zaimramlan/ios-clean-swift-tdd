//
//  MainWorkerSpec.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import Quick
import Nimble
import Mockingjay
@testable import CleanSwiftTDD

class MainWorkerSpec: QuickSpec {
    override func spec() {
        
        // MARK: - Subject Under Test (SUT)
        
        var sut: MainWorker!
        
        // MARK: - Test Doubles
        
        var networkStub: Stub!

        // MARK: - Tests
        
        beforeEach {
            setupWorker()
        }
        
        afterEach {
            removeNetworkStub()
            sut = nil
        }
        
        // MARK: Use Cases
        
        describe("fetch user data") {
            typealias UserData = (name: String?, email: String?)
            var actual: UserData = ("", "")

            beforeEach {
                // given
                stubNetwork(as: ["name": Seeds.name, "email": Seeds.email])
                
                // when
                sut.fetchUserData(completion: { (name, email) in
                    actual.name = name
                    actual.email = email
                })
            }
            
            it("should display the fetched user name", closure: {
                // then
                expect(actual.name).toEventually(equal(Seeds.name))
            })

            it("should display the fetched user email", closure: {
                // then
                expect(actual.email).toEventually(equal(Seeds.email))
            })
        }
        
        describe("perform log out") {
            it("should set user isLoggedIn status to false", closure: {
                // given
                UserDefaults.standard.set(nil, forKey: sut.userSessionStatusKey)
                let expectedUserStatus = false
                
                // when
                sut.performLogOut()
                
                // then
                let actualUserStatus = UserDefaults.standard.value(forKey: sut.userSessionStatusKey) as! Bool
                expect(actualUserStatus).to(equal(expectedUserStatus))
            })
        }
        
        // MARK: - Test Helpers
        
        func setupWorker() {
            sut = MainWorker()
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

extension MainWorkerSpec {
}
