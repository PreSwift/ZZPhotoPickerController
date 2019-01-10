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
import SnapKit
import QMUIKit

// 代理方式获取结果
@objc public protocol ZZPhotoPickerControllerDelegate : NSObjectProtocol {
    @objc optional func photoPickerController(_ photoPickerController: ZZPhotoPickerController, didSelect assets: [Any])
}

public class ZZPhotoPickerController: UINavigationController {
    /// 代理方法
    public weak var zzDelegate: ZZPhotoPickerControllerDelegate?
    
    /// 最大允许选择数量，默认9999
    public var maxSelectCount: Int = 9999 {
        didSet {
            collectionViewController.maxSelectCount = maxSelectCount
        }
    }
    
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
}

