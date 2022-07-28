//
//  Constants.swift
//  HomeTest
//
//  Created by Gaurang Patel on 22/07/22.
//

import UIKit

class Constants: NSObject {
   
    //Staging - https://api.mytaxi.com/poiservice/poi/v1
    //Prod - https://api.mytaxi.com/poiservice/poi/v2 (Something like that)
    
    //Change base url as per the requirement
    static let BaseURL = "https://api.mytaxi.com/poiservice/poi/v1"
        
    static let latLongUrl = "?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891"
}
