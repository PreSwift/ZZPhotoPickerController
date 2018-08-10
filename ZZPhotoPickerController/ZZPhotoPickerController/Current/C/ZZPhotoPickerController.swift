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

public enum ZZPhotoPickerMediaType {
    case image
    case video
}

// 代理方式获取结果
@objc public protocol ZZPhotoPickerControllerDelegate : NSObjectProtocol {
    @objc optional func photoPickerController(_ photoPickerController: ZZPhotoPickerController, didSelectImage assets: [Any])
    @objc optional func photoPickerController(_ photoPickerController: ZZPhotoPickerController, didSelectVideo avAsset: Any)
}

public class ZZPhotoPickerController: UINavigationController {
    
    public weak var zzDelegate: ZZPhotoPickerControllerDelegate?
    public var maxSelectCount: Int = 9999 {
        didSet {
            collectionViewController.maxSelectCount = maxSelectCount
        }
    }
    public var mediaType: ZZPhotoPickerMediaType = .image {
        didSet {
            collectionViewController.mediaType = mediaType
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
    
    deinit {
        print(self)
    }
}

