//
//  ApiService.swift
//  SAMI-LOTTERY
//
//  Created by Nguyễn Khoa on 10/18/17.
//  Copyright © 2017 Nguyễn Khoa. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiService: NSObject {
    
    static let sharedInstance = ApiService()
    var myString = String()
    
    let link = "http://megaball.vn:8080/api/soccer/admin"
    
    func send_loterry_data(dataPost: [String: Any], _ completion: @escaping (JSON) -> ()) {
        postDataForUrlString("\(link)/lottery/direct_ios", dataPost: dataPost, completion: completion)
    }
    
    //GET
    func getBaseString() -> String {
        let username = "twin"
        let password = "123456"
        let loginString = String(format: "%@:%@", username, password)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        return base64LoginString
    }
    func getDataForUrlString(_ urlString: String, completion: @escaping (JSON) -> ()) {
        print(urlString)
        //ACProgressHUD.shared.showHUD(withStatus: "Loading...")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var request = URLRequest(url: NSURL.init(string: urlString)! as URL)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Basic \(self.getBaseString())", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        
        Alamofire.request(request)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //ACProgressHUD.shared.hideHUD()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    DispatchQueue.main.async(execute: {
                        completion(json)
                    })
                case .failure(let error):
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    //ACProgressHUD.shared.hideHUD()
                    print(error)
                }
        }
    }
    
    
    //POST
    func postDataForUrlString(_ urlString: String, dataPost: [String: Any], completion: @escaping (JSON) -> ()) {
        print(urlString)
        print(dataPost)
        //ACProgressHUD.shared.showHUD(withStatus: "Loading...")
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var request = URLRequest(url: NSURL.init(string: urlString)! as URL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.setValue("Basic \(self.getBaseString())", forHTTPHeaderField: "Authorization")
        request.timeoutInterval = 10
        request.httpBody = try! JSONSerialization.data(withJSONObject: dataPost)
        
        Alamofire.request(request)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    let json = JSON(value)
                    //ACProgressHUD.shared.hideHUD()
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    DispatchQueue.main.async(execute: {
                        completion(json)
                        
                    })
                case .failure(let error):
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    //ACProgressHUD.shared.hideHUD()
                    print(error)
                }
        }
    }
    //POST curl
//    func postDataForUrlString_CURL(_ urlString: String, dataPost: [String: Any], completion: @escaping (JSON) -> ()) {
//        print(urlString)
//        print(dataPost)
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        //ACProgressHUD.shared.showHUD(withStatus: "Loading...")
//        var request = URLRequest(url: NSURL.init(string: urlString)! as URL)
//        request.httpMethod = "POST"
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("application/json", forHTTPHeaderField: "Accept")
//        request.setValue("Basic \(self.getBaseString())", forHTTPHeaderField: "Authorization")
//        request.timeoutInterval = 10
//
//        let appid = "d47d5ee4fd027d76fc4f1d3adf785a97"
//        request.setValue(appid, forHTTPHeaderField: "APIID")
//
//        let mktime = String(format: "%0.f", Date().timeIntervalSince1970)
//        request.setValue(mktime, forHTTPHeaderField: "APITIME")
//
//        let key = "53e8644558111d7dfb4a8bde04d9d3fb944c113badab2d91174d8f37161cfe84"
//        let md5 = String.init(format: "%@", dataPost)
//
//        let apiHash = String(format: "%@%@%@", mktime, appid, md5)
//        let cKey = key.cString(using: String.Encoding.ascii)
//        let cData = apiHash.cString(using: String.Encoding.ascii)
//        var result: [CUnsignedChar]
//        result = Array(repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
//        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), cKey, Int(strlen(cKey)), cData, Int(strlen(cData)), &result)
//        let hash = NSMutableString()
//        for val in result {
//            hash.appendFormat("%02x", val)
//        }
//        request.setValue(hash as String, forHTTPHeaderField: "APIHASH")
//
//        request.httpBody = try! JSONSerialization.data(withJSONObject: dataPost)
//
//        Alamofire.request(request)
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    let json = JSON(value)
//                    //ACProgressHUD.shared.hideHUD()
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    DispatchQueue.main.async(execute: {
//                        completion(json)
//                    })
//                case .failure(let error):
//                    //ACProgressHUD.shared.hideHUD()
//                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
//                    print(error)
//                }
//        }
//    }
}
