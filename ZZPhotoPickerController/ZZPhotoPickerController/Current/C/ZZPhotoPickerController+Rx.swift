//
//  ZZPhotoPickerController+Rx.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 3/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// rx订阅方式获取结果

extension Reactive where Base: ZZPhotoPickerController {
    
    var assetsSelected: ControlEvent<[Any]> {
        let source: Observable<[Any]> = self.zzDelegate.methodInvoked(#selector(ZZPhotoPickerControllerDelegate.photoPickerController(_:didSelectImage:))).map { a in
            return a[1] as! [Any]
        }
        return ControlEvent.init(events: source)
    }
    
    var avAssetSelected: ControlEvent<Any> {
        let source: Observable<Any> = self.zzDelegate.methodInvoked(#selector(ZZPhotoPickerControllerDelegate.photoPickerController(_:didSelectVideo:))).map { a in
            return a[1]
        }
        return ControlEvent.init(events: source)
    }
    
}

extension Reactive where Base: ZZPhotoPickerController {
    
    public var zzDelegate: DelegateProxy<ZZPhotoPickerController, ZZPhotoPickerControllerDelegate> {
        return RxPhotoPickerControllerDelegateProxy.proxy(for: base)
    }
    
}
