//
//  Vehicles.swift
//  HomeTest
//
//  Created by Gaurang Patel on 26/07/22.
//

import UIKit

class Vehicles: NSObject {
    var latitude : CGFloat?
    var longitude : CGFloat?
    var state : String?
    var type : String?
    var heading : CGFloat?
    var id : Int = 0

    init(json : NSDictionary?) {
        super.init()
        parseJson(json: json)
    }
    
    func parseJson(json : NSDictionary?) {
        guard let json = json else {
            return
        }
        
        let coordinate = json["coordinate"] as? NSDictionary
        if (coordinate != nil) {
            self.latitude = coordinate!["latitude"] as? CGFloat ?? 0.0
            self.longitude = coordinate!["longitude"] as? CGFloat ?? 0.0
        }
        self.id = json["id"] as? Int ?? 0
        self.state = json["state"] as? String ?? ""
        self.type = json["type"] as? String ?? ""
        self.heading = json["heading"] as? CGFloat ?? 0.0
    }
}
