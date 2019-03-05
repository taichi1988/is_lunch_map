//
//  UIExtension.swift
//  is_lunch_map
//
//  Created by 行木太一 on 2019/03/06.
//  Copyright © 2019 yukit.Inc. All rights reserved.
//

import UIKit

// Extensions for UI

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach(addSubview(_:))
    }
}

extension CALayer {
    func setCorner(radius: CGFloat) {
        cornerRadius = radius
        masksToBounds = true
    }
}
