//
//  Network.swift
//  ixigo Assignment
//
//  Created by GAURAV NAYAK on 01/07/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import Foundation

import Foundation
import Alamofire
import SwiftyJSON

class NetworkController {
    
    func getRequest(urlString: String, completionHandler: @escaping (Bool, JSON) -> Void ) {
        
        Alamofire.request(URL(string: urlString)!).responseJSON { (response) in
            do {
                let json = try JSON(data: response.data!)
                
                if response.response!.statusCode >= 200 && response.response!.statusCode < 300 {
                    completionHandler(true, json)
                }
                else {
                    completionHandler(false, JSON.null)
                }
                
            } catch{
                print(error)
                completionHandler(false, JSON.null)
            }
        }
    }
}

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
