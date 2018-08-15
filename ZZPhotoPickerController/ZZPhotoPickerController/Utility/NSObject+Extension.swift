//
//  NSObject+Extension.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 13/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import CoreMedia

extension NSObject {
    
    var imageBundle: Bundle? {
        if let bundleUrl = Bundle.init(for: self.classForCoder).url(forResource: "ZZPhoto_Images", withExtension: "bundle") {
            return Bundle.init(url: bundleUrl)
        } else {
            return nil
        }
    }
    
    func getGifImagesFrom(data: Data, completion: ((_ images: [UIImage], _ duration: TimeInterval) -> Void)?) {
        DispatchQueue.global().async {
            let options: NSDictionary = [kCGImageSourceShouldCache as String: NSNumber(value: true), kCGImageSourceTypeIdentifierHint as String: kCMMetadataBaseDataType_GIF]
            let imageSource = CGImageSourceCreateWithData(data as CFData, options)
            // 获取gif帧数
            let frameCount = CGImageSourceGetCount(imageSource!)
            var images = [UIImage]()
            
            var gifDuration = 0.0
            
            for i in 0 ..< frameCount {
                // 获取对应帧的 CGImage
                guard let imageRef = CGImageSourceCreateImageAtIndex(imageSource!, i, options) else {
                    return
                }
                if frameCount == 1 {
                    // 单帧
                    gifDuration = Double.infinity
                } else{
                    // gif 动画
                    // 获取到 gif每帧时间间隔
                    guard let properties = CGImageSourceCopyPropertiesAtIndex(imageSource!, i, nil) , let gifInfo = (properties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary,
                        let frameDuration = (gifInfo[kCGImagePropertyGIFDelayTime as String] as? NSNumber) else
                    {
                        return
                    }
                    //                print(frameDuration)
                    gifDuration += frameDuration.doubleValue
                    // 获取帧的img
                    let  image = UIImage.init(cgImage: imageRef, scale: UIScreen.main.scale, orientation: .up)
                    // 添加到数组
                    images.append(image)
                }
            }
            DispatchQueue.main.async {
                completion?(images, gifDuration)
            }
        }
    }

    
}
