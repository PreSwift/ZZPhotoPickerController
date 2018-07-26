//
//  ZZPhotoGroupModel.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import Photos

class ZZPhotoGroupModel: NSObject {

    var assetCollection: PHAssetCollection
    var fetchResult: PHFetchResult<PHAsset>
    var noVideoFetchResult: PHFetchResult<PHAsset>
    
    init(assetCollection: PHAssetCollection, fetchResult: PHFetchResult<PHAsset>, noVideoFetchResult: PHFetchResult<PHAsset>) {
        self.assetCollection = assetCollection
        self.fetchResult = fetchResult
        self.noVideoFetchResult = noVideoFetchResult
    }
    
}
