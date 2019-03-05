//
//  FoundationExtension.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2019/03/06.
//  Copyright © 2019 yukit.Inc. All rights reserved.
//

import Foundation

// Extensions for Foundation

extension Optional {
    var isNil: Bool {
        switch self {
        case .some: return false
        case .none: return true
        }
    }
    
    var isNotNil: Bool {
        return !isNil
    }
}
