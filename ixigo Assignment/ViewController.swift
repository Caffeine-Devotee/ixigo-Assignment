//
//  ViewController.swift
//  ixigo Assignment
//
//  Created by GAURAV NAYAK on 01/07/19.
//  Copyright © 2019 GAURAV NAYAK. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController {
    
    var airlineMap : [String : JSON] = [:]
    var airportMap : [String : JSON] = [:]
    var flightsData = [FlightsData]()

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func priceAction(_ sender: Any) {
        self.flightsData = SampleFlightModelData.shared.sortByPrice(flight: self.flightsData)
        self.collectionView.reloadData()
    }
    
    @IBAction func departureAction(_ sender: Any) {
        self.flightsData = SampleFlightModelData.shared.sortByDeparture(flight: self.flightsData)
        self.collectionView.reloadData()
    }
    
    @IBAction func arrivalAction(_ sender: Any) {
        self.flightsData = SampleFlightModelData.shared.sortByArrival(flight: flightsData)
        self.collectionView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if Connectivity.isConnectedToInternet() {
            SampleFlightModelData.shared.getSampleFlightData() {
                (flightsData, airlineMap, airportMap) in
                if flightsData != nil {
                    self.flightsData = flightsData!
                    self.airlineMap = airlineMap as! [String : JSON]
                    self.airportMap = airportMap as! [String : JSON]
                    self.collectionView.reloadData()
                }
                else {
                    self.alertView(message: "Something went wrong, Please try again.")
                }
                
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !Connectivity.isConnectedToInternet() {
            self.alertView(message: "No Internet Connection Please check and Retry.")
        }
    }
    
    func alertView(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
                
            case .cancel:
                print("cancel")
                
            case .destructive:
                print("destructive")
                
            @unknown default:
                print("Other")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.flightsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! MyCell

        cell.classLabel.text = self.flightsData[indexPath.row].classes
        cell.originTime.text =  SampleFlightModelData.shared.convertTo24Hrs(time: self.flightsData[indexPath.row].takeoffTime!) + " - "
        cell.destinationTime.text =  SampleFlightModelData.shared.convertTo24Hrs(time: self.flightsData[indexPath.row].landingTime!)
        cell.expensive.text = "Rs " + self.flightsData[indexPath.row].price!
        cell.imageView.image = UIImage(named: self.flightsData[indexPath.row].airlineCode!)
        cell.takeOffDate.text = SampleFlightModelData.shared.convertToDate(time: self.flightsData[indexPath.row].takeoffTime!) + "  -  "
        cell.landingDate.text = SampleFlightModelData.shared.convertToDate(time: self.flightsData[indexPath.row].landingTime!)
        
        return cell
    }
}
