//
//  RequestProtocol.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2018/08/05.
//  Copyright © 2018年 yukit.Inc. All rights reserved.
//

import Alamofire
import ObjectMapper

protocol RequestProtocol: URLRequestConvertible {
    associatedtype ResponseType
    
    var baseURL: String { get }
    var method: Alamofire.HTTPMethod { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var parameters: Parameters? { get }
    var encoding: URLEncoding { get }
    func fromJson(_ json: AnyObject) -> Result<ResponseType>
}

extension RequestProtocol {
    var baseURL: String {
        return "https://script.google.com/macros/s/AKfycbw_KgwrwZflExGHq2ia102Y9HC_ZIF0GwjbIbO-dQr38u5gM-E/exec?action=shop_list"
    }
    
    var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var encoding: URLEncoding {
        return .methodDependent
    }
    
    func asURLRequest() throws -> URLRequest {
        let urlString = baseURL + path
        let encodedUrl = urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: encodedUrl!)!
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringLocalCacheData
        urlRequest.timeoutInterval = TimeInterval(30)
        urlRequest.allHTTPHeaderFields = headers
        if let parameters = parameters {
            urlRequest.httpBody =
                try JSONSerialization.data(withJSONObject: parameters, options: JSONSerialization.WritingOptions())
        }
        
        return urlRequest
    }
}

extension RequestProtocol where ResponseType: Mappable {
    func fromJson(_ json: AnyObject) -> Result<ResponseType> {
        guard let value = Mapper<ResponseType>().map(JSONObject: json) else {
            let errorInfo = [NSLocalizedDescriptionKey: "Mapping object failed",
                             NSLocalizedRecoverySuggestionErrorKey: "Rainy days never stay."]
            let error = NSError(domain: Bundle.main.bundleIdentifier!, code: 0, userInfo: errorInfo)
            return .failure(error)
        }
        return .success(value)
    }
}


