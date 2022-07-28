//
//  APIManager.swift
//  HomeTest
//
//  Created by Gaurang Patel on 22/07/22.
//

import UIKit
import Alamofire

@objc public enum RequestMethod:Int {
    case POST
    case GET
}

fileprivate protocol WebClientAF {
    func loadRequestWith(url:URL, httpMethod: Alamofire.HTTPMethod, parameters:[String:Any]?,encoding:ParameterEncoding, completionHandler: @escaping (_ response:NSDictionary?)->Void) throws;
}

@objc public class APIRequestManager:NSObject {
    private var baseUrl:String;
   
    public var header:HTTPHeaders? = {
        var header:HTTPHeaders = [:]
        header["Content-Type"] = "text/plain"
        header["Accept"] = "application/json"
               
        return header;
    }()
   
    @objc override init() {
        self.baseUrl =  Constants.BaseURL
        
        super.init()
    }
    
    public func loadRequestWithPage(method:RequestMethod, url:URL, parameters:[String:Any]?,encoding:ParameterEncoding = URLEncoding.default, completionHandler: @escaping (_ response:NSDictionary?)->Void) throws {
   
    switch method {
        case .GET:
                loadRequestWith(url: url, httpMethod: .get,encoding: encoding, completionHandler: completionHandler)

            break
        
        case .POST:
                 loadRequestWith(url: url, httpMethod: .post, parameters: parameters,encoding: encoding, completionHandler: completionHandler)
        }
    }
}

//TODO: URL Encoded Api
extension APIRequestManager:WebClientAF {
        
    fileprivate func loadRequestWith(url:URL, httpMethod: Alamofire.HTTPMethod, parameters:[String : Any]? = nil,encoding:ParameterEncoding = URLEncoding.default, completionHandler: @escaping (_ response:NSDictionary?)->Void) {
        
        AF.request(url.absoluteString, method: httpMethod, parameters: parameters, encoding: encoding, headers: header).response { (response) in
            guard let _ = response.data  else{
                completionHandler(["error":"Invalid response"])
                return
            }
            do {
               if let responseDict = try JSONSerialization.jsonObject(with: response.data!, options: .mutableContainers) as? NSDictionary {
                   completionHandler(responseDict)
               
               } else if let responseArray = try JSONSerialization.jsonObject(with: response.data!, options: .allowFragments) as? Array<Any>{
            
                let dictionary :[String :Any] = ["responseData":responseArray];
                completionHandler(dictionary as NSDictionary)
                }

            }catch {
                debugPrint("Response Erro \(error.localizedDescription)" )
                completionHandler(nil)
            }
        }        
    }
}
