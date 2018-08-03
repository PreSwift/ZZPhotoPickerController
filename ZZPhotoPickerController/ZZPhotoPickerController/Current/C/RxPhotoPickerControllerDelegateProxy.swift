//
//  RxPhotoPickerControllerDelegateProxy.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 3/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxPhotoPickerControllerDelegateProxy: DelegateProxy<ZZPhotoPickerController, ZZPhotoPickerControllerDelegate>, DelegateProxyType, ZZPhotoPickerControllerDelegate {
    
    /// Typed parent object.
    public weak private(set) var photoPickerController: ZZPhotoPickerController?
    
    /// - parameter scrollView: Parent object for delegate proxy.
    public init(photoPickerController: ParentObject) {
        self.photoPickerController = photoPickerController
        super.init(parentObject: photoPickerController, delegateProxy: RxPhotoPickerControllerDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        self.register { RxPhotoPickerControllerDelegateProxy(photoPickerController: $0) }
    }
    
    static func currentDelegate(for object: ZZPhotoPickerController) -> ZZPhotoPickerControllerDelegate? {
        return object.zzDelegate
    }
    
    static func setCurrentDelegate(_ delegate: ZZPhotoPickerControllerDelegate?, to object: ZZPhotoPickerController) {
        object.zzDelegate = delegate
    }
    
}
