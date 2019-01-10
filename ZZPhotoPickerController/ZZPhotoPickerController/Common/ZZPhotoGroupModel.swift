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
    var assets: [PHAsset]
    var isContainSelectedAssets: Bool = false
    var isCurrentGroup: Bool = false
    
    init(assetCollection: PHAssetCollection, assets: [PHAsset]) {
        self.assetCollection = assetCollection
        self.assets = assets
    }
    
}
