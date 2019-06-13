//
//  UIImagePickerController.swift
//  InstaGrid
//
//  Created by Quentin Marlas on 13/06/2019.
//  Copyright © 2019 Quentin Marlas. All rights reserved.
//

import UIKit

extension UIImagePickerController {
    open override var shouldAutorotate: Bool { return true }
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask { return .all }
}
