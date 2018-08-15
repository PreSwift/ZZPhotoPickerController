//
//  NSObject+Extension.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 13/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
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
