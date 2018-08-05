//
//  ShopListRequest.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2018/08/05.
//  Copyright © 2018年 yukit.Inc. All rights reserved.
//

import Alamofire
import ObjectMapper

struct ShopListRequest: RequestProtocol {
    typealias ResponseType = ShopList
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: String {
        return ""
    }
}
