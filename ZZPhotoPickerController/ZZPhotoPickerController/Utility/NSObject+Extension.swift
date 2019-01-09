//
//  NSObject+Extension.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 9/1/2019.
//  Copyright © 2019 周元素. All rights reserved.
//

import UIKit

extension NSObject {

    var imageBundle: Bundle? {
        if let bundleUrl = Bundle.init(for: self.classForCoder).url(forResource: "ZZPhoto_Images", withExtension: "bundle") {
            return Bundle.init(url: bundleUrl)
        } else {
            return nil
        }
    }
    
}
