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

// 代理方式获取结果
@objc public protocol ZZPhotoPickerControllerDelegate : NSObjectProtocol {
    @objc optional func photoPickerController(_ photoPickerController: ZZPhotoPickerController, didSelect assets: [Any])
}

public class ZZPhotoPickerController: UINavigationController {
    
    public weak var zzDelegate: ZZPhotoPickerControllerDelegate?
    
    required public init() {
        let collectionViewController = ZZPhotoCollectionViewController()
        super.init(rootViewController: collectionViewController)
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

