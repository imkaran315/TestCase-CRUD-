//
//  Extensions.swift
//  TestCase CRUD
//
//  Created by Karan Verma on 06/10/24.
//
import UIKit
import Foundation

extension UIColor{
    static func rgb(_ red: CGFloat, _ green: CGFloat, _ blue: CGFloat, _ alpha: CGFloat = 1) -> UIColor{
        return UIColor(red: red/256, green: green/256, blue: blue/256, alpha: alpha)
    }
}
