//
//  MainModels.swift
//  CleanSwiftTDD
//
//  Created by Zaim Ramlan on 25/02/2019.
//  Copyright (c) 2019 Zaim Ramlan. All rights reserved.
//

import UIKit

enum MainModels {

    // MARK: - Use Cases
    
    enum FetchFromDataStore {
        struct Request {
            
        }
        
        struct Response {
            var name: String
            var email: String
        }
    
        struct ViewModel {
            var name: String
            var email: String
        }
    }
    
    enum LogOut {
        struct Request {
            var amount: String
        }
        
        struct Response {
            var amount: Decimal
        }
        
        struct ViewModel {
            
        }
    }

    enum TrackAnalytics {
        struct Request {
        }

        struct Response {
        }

        struct ViewModel {
        }
    }

    enum PerformMain {
        struct Request {
        }

        struct Response {
        }

        struct ViewModel {
        }
    }

    // MARK: - View Models

    enum MainErrorType {
        case emptyExampleVariable, apiError
    }

    struct Error<T> {
        var type: T
        var message: String?

        init(type: T) {
            self.type = type
        }
    }
}
