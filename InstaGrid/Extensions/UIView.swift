//
//  UIView.swift
//  InstaGrid
//
//  Created by Quentin Marlas on 06/06/2019.
//  Copyright © 2019 Quentin Marlas. All rights reserved.
//

import UIKit

extension UIView {
    
    func convertToImage() -> UIImage? {
        UIGraphicsBeginImageContext(bounds.size)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        guard let image = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return image
    }
}
