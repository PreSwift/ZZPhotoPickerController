//
//  ZZPhotoPickerController.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

public class ZZPhotoPickerController: UINavigationController {
    
    public var zzDelegate: ZZPhotoPickerControllerDelegate?
    
    private var collectionViewController: ZZPhotoCollectionViewController!
    
    required public init() {
        let collectionViewController = ZZPhotoCollectionViewController()
        super.init(rootViewController: collectionViewController)
        self.collectionViewController = collectionViewController
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print(self)
    }
}

// 代理方式获取结果
@objc public protocol ZZPhotoPickerControllerDelegate {
    @objc func photoPickerController(_ photoPickerController: ZZPhotoPickerController, didSelect assets: [Any])
}

// rx订阅方式获取结果
extension Reactive where Base: ZZPhotoPickerController {
    
    public var assetsSelected: ControlEvent<[Any]> {
        let source = delegate.methodInvoked(#selector(ZZPhotoPickerControllerDelegate.photoPickerController(_:didSelect:)))
        return ControlEvent(events: source)
    }
    
}
