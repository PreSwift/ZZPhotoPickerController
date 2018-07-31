//
//  UIImage+Extension.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 31/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit

extension UIImage {
    
    convenience init?(color: UIColor) {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            self.init(cgImage: image.cgImage!)
        } else {
            self.init()
        }
        UIGraphicsEndImageContext()
    }
    
}
