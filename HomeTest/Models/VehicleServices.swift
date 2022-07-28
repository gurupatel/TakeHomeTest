//
//  VehicleServices.swift
//  HomeTest
//
//  Created by Gaurang Patel on 26/07/22.
//

import Foundation
import Alamofire

class VehicleServices: NSObject {
    
    static let shared = VehicleServices()
    
    func callGetListAPI(completion: @escaping (_ response: NSDictionary?, _ error: Error?) -> Void) {
        
        let urlString: String = String(format: "%@%@", Constants.BaseURL, Constants.latLongUrl)
        do {
            guard let url = URL(string: urlString) else {
                return
            }
            try APIRequestManager().loadRequestWithPage(method: .GET, url: url, parameters: nil) { (response) in
                //debugPrint("Server response : ", response as Any)
                let serverResponseDict = response
                if (serverResponseDict != nil) {
                    completion(serverResponseDict, nil)
                }
            }
        } catch {
            debugPrint("Remote API Error for \(error.localizedDescription)")
            completion(nil, error)
        }
    }
}
