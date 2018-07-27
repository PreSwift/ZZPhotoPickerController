//
//  ZZPhotoOperationService.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Photos

@objc enum ZZPhotoOperationStatus: Int {
    case normal
    case noPermission
    case noAsset
}

class ZZPhotoOperationService: NSObject {
    
    @objc dynamic var currentGroup: ZZPhotoGroupModel!
    @objc dynamic var operationStatus = ZZPhotoOperationStatus.normal
    var selectedAssets = BehaviorRelay<[PHAsset]>(value: [])
    var groups = BehaviorRelay<[ZZPhotoGroupModel]>(value: [])
    
    var cachingManager: PHCachingImageManager?
    
    let disposeBag = DisposeBag()
    
    required override init() {
        super.init()
        
        fetchPhotoGroups()
        
        NotificationCenter.default.rx.notification(.UIApplicationDidBecomeActive).subscribe(onNext: { [weak self] (_) in
            self?.fetchPhotoGroups()
        }).disposed(by: disposeBag)
        
        // 缓存
        self.rx.observeWeakly(ZZPhotoGroupModel.self, "currentGroup", options: [.new]).take(1).subscribe(onNext: { [weak self] (value) in
            guard let strongSelf = self else { return }
            print("222222222232323222222222222222222222")
            if let newValue = value {
                strongSelf.cachingManager?.startCachingImages(for:newValue.imageAssets , targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil)
            }
        }).disposed(by: disposeBag)
    }
    
    func fetchPhotoGroups() {
        if currentGroup != nil {
            return
        }
        PHPhotoLibrary.requestAuthorization { (status) in
            if status == .notDetermined {
                // do nothing
            } else if status == .authorized {
                // 初始化缓存实例
                self.cachingManager = PHCachingImageManager()
                DispatchQueue.init(label: "ZZPhotoViewModel.fetchGroupQueue").async {
                    // 检索智能相册
                    let smartAlbumsResult = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .albumRegular, options: nil)
                    smartAlbumsResult.enumerateObjects { [weak self] (obj0, idx0, stop0) in
                        guard let strongSelf = self else { return }
                        
                        if obj0.isKind(of: PHAssetCollection.classForCoder()) {
                            let assetCollection = obj0
                            let options = PHFetchOptions()
                            options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
                            let result = PHAsset.fetchAssets(in: assetCollection, options: options)
                            options.predicate = NSPredicate.init(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                            let imageResult = PHAsset.fetchAssets(in: assetCollection, options: options)
                            if result.count > 0 {
                                if assetCollection.assetCollectionSubtype != PHAssetCollectionSubtype.init(rawValue: 1000000201) {
                                    var items = [PHAsset]()
                                    result.enumerateObjects({ (asset, index, nil) in
                                        items.append(asset)
                                    })
                                    
                                    var imageItems = [PHAsset]()
                                    imageResult.enumerateObjects({ (asset, index, nil) in
                                        imageItems.append(asset)
                                    })
                                    
                                    let group = ZZPhotoGroupModel.init(assetCollection: assetCollection, assets: items, imageAssets: imageItems)
                                    strongSelf.groups.accept(strongSelf.groups.value + [group])
                                    
                                    // 默认选中所有相册
                                    if assetCollection.assetCollectionSubtype == .smartAlbumUserLibrary {
                                        strongSelf.currentGroup = group
                                    }
                                }
                            } else {
                                if assetCollection.assetCollectionSubtype == .smartAlbumUserLibrary {
                                    self?.operationStatus = .noAsset
                                }
                            }
                        }
                    }
                    // 检索用户相册
                    let userAlbumsResult = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .smartAlbumUserLibrary, options: nil)
                    userAlbumsResult.enumerateObjects { [weak self] (obj0, idx0, stop0) in
                        guard let strongSelf = self else { return }
                        
                        if obj0.isKind(of: PHAssetCollection.classForCoder()) {
                            let assetCollection = obj0
                            let options = PHFetchOptions()
                            options.sortDescriptors = [NSSortDescriptor.init(key: "creationDate", ascending: false)]
                            let result = PHAsset.fetchAssets(in: assetCollection, options: options)
                            options.predicate = NSPredicate.init(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                            let imageResult = PHAsset.fetchAssets(in: assetCollection, options: options)
                            
                            if result.count > 0 {
                                var items = [PHAsset]()
                                result.enumerateObjects({ (asset, index, nil) in
                                    items.append(asset)
                                })
                                
                                var imageItems = [PHAsset]()
                                imageResult.enumerateObjects({ (asset, index, nil) in
                                    imageItems.append(asset)
                                })
                                
                                let group = ZZPhotoGroupModel.init(assetCollection: assetCollection, assets: items, imageAssets: imageItems)
                                strongSelf.groups.accept(strongSelf.groups.value + [group])
                            }
                        }
                    }
                    // 相册排序
                    if self.groups.value.count > 1 {
                        var newArray = self.groups.value
                        newArray.sort(by: { (obj1, obj2) -> Bool in
                            if obj1.assetCollection.assetCollectionSubtype == .smartAlbumUserLibrary {
                                return true
                            }
                            return false
                        })
                        self.groups.accept(newArray)
                    }
                }
            } else {
                self.operationStatus = .noPermission
            }
        }
    }
    
    deinit {
        cachingManager?.stopCachingImagesForAllAssets()
        print(self)
    }

}
