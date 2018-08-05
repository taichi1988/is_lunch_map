//
//  APIClient.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2018/08/05.
//  Copyright © 2018年 yukit.Inc. All rights reserved.
//

import Alamofire
import ObjectMapper
import RxSwift

class ApiClient {
    /// API Request and Return Observable
    static func request<T: RequestProtocol, V>(_ request: T) -> Single<V> where T.ResponseType == V {
        return Single<V>.create { observer in
            self.request(request) { response in
                switch response {
                case .success(let value):
                    observer(.success(value))
                case .failure(let error):
                    observer(.error(error))
                }
            }
            return Disposables.create()
        }
    }
    
    /// API Request
    static private func request<T: RequestProtocol, V>(_ request: T, isCheckOffline: Bool = false, completion: @escaping (Result<V>) -> Void) where T.ResponseType == V {
        Alamofire.request(request).responseJSON { response in
            let statusCode: Int = response.response?.statusCode ?? 0
            let url: String = response.request?.url?.absoluteString ?? ""
            let isSuccess: Bool = response.result.isSuccess
            let method: String = response.request?.httpMethod ?? ""
            let parameters: Parameters = request.parameters ?? [:]
            let header: [String : String] = response.request?.allHTTPHeaderFields ?? [:]
            let timeout: TimeInterval = response.request?.timeoutInterval ?? 0
            
            switch response.result {
            case .success(let json):
                #if DEBUG
                    var log = "\n\n"
                    log += "*****************************************************************\n"
                    log += "*** RESPONSE SUCCESS ********************************************\n"
                    log += "url       :\(url)\n"
                    log += "isSuccess :\(isSuccess)\n"
                    log += "status    :\(statusCode)\n"
                    log += "method    :\(method)\n"
                    log += "params    :\(parameters)\n"
                    log += "header    :\(header)\n"
                    log += "timeout   :\(timeout)\n"
                    log += "response  :\n"
                    log += "\(json)\n"
                    log += "*** ENDLINE *****************************************************\n"
                    log += "*****************************************************************\n"
                    print(log)
                #endif
                
                completion(request.fromJson(json as AnyObject))
                
            case .failure(let error):
                #if DEBUG || ADHOC || STAGING
                    var log = "\n\n"
                    log += "*****************************************************************\n"
                    log += "*** RESPONSE Failure ********************************************\n"
                    log += "url       :\(url)\n"
                    log += "isSuccess :\(isSuccess)\n"
                    log += "status    :\(statusCode)\n"
                    log += "method    :\(method)\n"
                    log += "params    :\(parameters)\n"
                    log += "header    :\(header)\n"
                    log += "timeout   :\(timeout)\n"
                    log += "Error     :\(error)\n"
                    log += "*** ENDLINE *****************************************************\n"
                    log += "*****************************************************************\n"
                    print(log)
                #endif
                
                completion(.failure(error))
            }
        }
    }
}
