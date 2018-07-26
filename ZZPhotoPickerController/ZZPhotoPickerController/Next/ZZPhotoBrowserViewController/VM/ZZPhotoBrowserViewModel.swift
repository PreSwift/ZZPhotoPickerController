//
//  ZZPhotoBrowserViewModel.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import Photos
class ZZPhotoBrowserViewModel: NSObject {

    weak var target: ZZPhotoBrowserViewController!
    weak var photoOperationService: ZZPhotoOperationService!
    
    required init(target: ZZPhotoBrowserViewController, photoOperationService: ZZPhotoOperationService) {
        super.init()
        self.target = target
        self.photoOperationService = photoOperationService
        
    }
    
}
