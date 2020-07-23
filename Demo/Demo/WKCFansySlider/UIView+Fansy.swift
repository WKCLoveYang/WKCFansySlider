//
//  UIView+Fansy.swift
//  SwiftFuck
//
//  Created by wkcloveYang on 2020/7/23.
//  Copyright © 2020 wkcloveYang. All rights reserved.
//

import UIKit

extension UIView {
    
    var fansy_x: CGFloat? {
        set {
            if let value = newValue {
                frame = CGRect(x: value, y: frame.origin.y, width: frame.width, height: frame.height)
            }
        }
        get {
            return frame.origin.x
        }
    }
    
    var fansy_y: CGFloat? {
        set {
            if let value = newValue {
                frame = CGRect(x: frame.origin.x, y: value, width: frame.width, height: frame.height)
            }
        }
        get {
            return frame.origin.y
        }
    }
    
    var fansy_width: CGFloat? {
        set {
            if let value = newValue {
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: value, height: frame.height)
            }
        }
        get {
            return frame.width
        }
    }
    
    var fansy_height: CGFloat? {
        set {
            if let value = newValue {
                frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.width, height: value)
            }
        }
        get {
            return frame.height
        }
    }
    
    var fansy_centerX: CGFloat? {
        set {
            if let value = newValue {
                center = CGPoint(x: value, y: center.y)
            }
        }
        get {
            return center.x
        }
    }
    
    var fansy_centerY: CGFloat? {
        set {
            if let value = newValue {
                center = CGPoint(x: center.x, y: value)
            }
        }
        get {
            return center.y
        }
    }
    
}
