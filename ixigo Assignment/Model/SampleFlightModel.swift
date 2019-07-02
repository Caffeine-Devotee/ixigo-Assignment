//
//  SampleFlightModel.swift
//  ixigo Assignment
//
//  Created by GAURAV NAYAK on 01/07/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import Foundation
import SwiftyJSON

class SampleFlightModelData {
    
    static let shared = SampleFlightModelData()
    let networkRequest = NetworkController.init()
    let url = "https://www.ixigo.com/sampleFlightData"
    
    init() {
        return
    }
    
    func getSampleFlightData(completionHandler: @escaping ([FlightsData]?, Dictionary<String, Any>, Dictionary<String, Any>) -> Void) {
        var flightsData = [FlightsData]()
        var airlineMap : [String : JSON] = [:]
        var airportMap : [String : JSON] = [:]
        networkRequest.getRequest(urlString: url) {
            (check, json) in
            if check {
                for (_, subJson) in json["flightsData"] {
                    flightsData.append(FlightsData(originCode: subJson["originCode"].string,
                                                   destinationCode: subJson["destinationCode"].string,
                                                   takeoffTime: subJson["takeoffTime"].string,
                                                   landingTime: subJson["landingTime"].string,
                                                   price: subJson["price"].string,
                                                   airlineCode: subJson["airlineCode"].string,
                                                   classes: subJson["class"].string))
                }
                airlineMap = json["airlineMap"].dictionary!
                airportMap = json["airportMap"].dictionary!
                
                completionHandler(flightsData, airlineMap, airportMap)
            }
            else {
                completionHandler(nil, airlineMap, airportMap)
            }
        }
    }
    
    func convertTo24Hrs(time : String) -> String {
        let date = Date(timeIntervalSince1970: Double(time)! )
        let calendar = Calendar.current
        let time=calendar.dateComponents([.hour,.minute], from: date)
        
        print(date)
        
        return "\(time.hour!):\(time.minute!)"
    }
    
    func convertToDate(time : String) -> String {
        let date = Date(timeIntervalSince1970: Double(time)! )
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        return dateFormatter.string(from: date)
    }
    
    func sortByPrice(flight : [FlightsData]) -> [FlightsData] {
        var fl = flight
        fl.sort {
            Int($0.price!)! < Int($1.price!)!
        }
        return fl
    }
    
    func sortByDeparture(flight : [FlightsData]) -> [FlightsData] {
        var fl = flight
        fl.sort {
            Double($0.takeoffTime!)! < Double($1.takeoffTime!)!
        }
        return fl
    }
    
    func sortByArrival(flight : [FlightsData]) -> [FlightsData] {
        var fl : [FlightsData] = flight
        fl.sort {
            $0.landingTime! < $1.landingTime!
        }
        return fl
    }
}
