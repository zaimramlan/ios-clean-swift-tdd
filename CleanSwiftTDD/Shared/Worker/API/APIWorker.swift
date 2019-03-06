//
//  APIWorker.swift
//  HelloGold
//
//  Created by Zaim Ramlan on 03/01/2018.
//  Copyright © 2018 HelloGold. All rights reserved.
//

import Foundation
import Alamofire

class APIWorker {
    
    // MARK: - Properties

    init() {}
    
    // MARK: - Main Methods

    func request(api: String, method: HTTPMethod, parameters: Parameters? = nil, headers: HTTPHeaders? = nil, endpointName: String, completion: @escaping (DataResponse<Any>) -> Void) {
        
        // Parameter Encoding
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        
        // Perform Request
        Alamofire.request(api, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON {
            response in
            
            print("\n*******************************************************")
            print("APIWorker: \(endpointName)\n")
            
            print("API url: ", api)
            print("params: ", parameters ?? [:])
            print("response: ", response)

            print("*******************************************************\n")
            
            // Get Response
            completion(response)
        }
    }
}

// MARK: - API Response Models

extension APIWorker {
    struct FetchUserDataResponse: Codable {
        var email: String
        var name: String
    }
}

// MARK: - API Requests

extension APIWorker {
    func fetchUserData(completion: @escaping (_ response: FetchUserDataResponse?) -> Void) {
        request(api: "https://some.domain.com/api/user_data.json", method: .get, endpointName: "User Data API") { (response) in
            guard
                let data = response.data,
                let decodedData = try? JSONDecoder().decode(FetchUserDataResponse.self, from: data)
            else {
                completion(nil)
                return
            }
            
            completion(decodedData)
        }
    }
}
