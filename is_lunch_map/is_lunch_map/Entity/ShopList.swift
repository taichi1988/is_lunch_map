//
//  ShopList.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2018/08/05.
//  Copyright © 2018年 yukit.Inc. All rights reserved.
//

import ObjectMapper

struct ShopList: Mappable {
    var shops: [Shop] = []
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        shops <- map["items"]
    }
}

struct Shop: Mappable {
    var id: Int = 0
    var shopName: String = ""
    var shopNameKana: String = ""
    var latitude: Float = 0
    var longitude: Float = 0
    var tabelogUrl: URL?
    var smokingFlag: Bool = false
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        shopName <- map["shop_name"]
        shopNameKana <- map["shop_name_kana"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        tabelogUrl <- (map["tabelog_url"], URLTransform())
        smokingFlag <- map["smoking_flag"]
    }
}
