//
//  UIView+Extensions.swift
//  Pizza App
//
//  Created by Akshansh Thakur on 03/08/20.
//  Copyright © 2020 Akshansh Thakur. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        
        var viewsDict = [String: UIView]()
        
        for (index, view) in views.enumerated() {
            
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDict["v\(index)"] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDict))
    }
}
