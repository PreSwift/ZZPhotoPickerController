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
    
    @objc dynamic var isGroupViewShow: Bool = false
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
        
        // 监听选中改变预览按钮状态
        self.selectedAssets.subscribe(onNext: { [weak self] (assets) in
            guard let strongSelf = self else { return }
            let groups = strongSelf.groups.value
            for group in groups {
                var isContainSelectedAssets = false
                for asset in assets {
                    if group.assets.contains(asset) {
                        isContainSelectedAssets = true
                        break
                    }
                }
                group.isContainSelectedAssets = isContainSelectedAssets
            }
            strongSelf.groups.accept(groups)
        }).disposed(by: disposeBag)
        
        self.rx.observeWeakly(ZZPhotoGroupModel.self, "currentGroup", options: [.new]).subscribe(onNext: { [weak self] (value) in
            guard let strongSelf = self else { return }
            if let newValue = value {
                let groups = strongSelf.groups.value
                for group in groups {
                    group.isCurrentGroup = group == newValue
                }
                strongSelf.groups.accept(groups)
            }
        }).disposed(by: disposeBag)
        
        self.rx.observeWeakly(ZZPhotoGroupModel.self, "currentGroup", options: [.new]).take(1).subscribe(onNext: { [weak self] (value) in
            guard let strongSelf = self else { return }
            print("222222222232323222222222222222222222")
            if let newValue = value {
                if strongSelf.currentGroup.assetCollection.assetCollectionSubtype != .smartAlbumVideos && strongSelf.currentGroup.assetCollection.assetCollectionSubtype != .smartAlbumSlomoVideos {
                    strongSelf.cachingManager?.startCachingImages(for:newValue.assets , targetSize: PHImageManagerMaximumSize, contentMode: .default, options: nil)
                }
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
                            if obj0.assetCollectionSubtype != .smartAlbumVideos && obj0.assetCollectionSubtype != .smartAlbumSlomoVideos {
                                options.predicate = NSPredicate.init(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                            }
                            let result = PHAsset.fetchAssets(in: assetCollection, options: options)
                            if result.count > 0 {
                                if assetCollection.assetCollectionSubtype != PHAssetCollectionSubtype.init(rawValue: 1000000201) {
                                    var items = [PHAsset]()
                                    result.enumerateObjects({ (asset, index, nil) in
                                        items.append(asset)
                                    })
                                    
                                    let group = ZZPhotoGroupModel.init(assetCollection: assetCollection, assets: items)
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
                            if obj0.assetCollectionSubtype != .smartAlbumVideos && obj0.assetCollectionSubtype != .smartAlbumSlomoVideos {
                                options.predicate = NSPredicate.init(format: "mediaType = %d", PHAssetMediaType.image.rawValue)
                            }
                            let result = PHAsset.fetchAssets(in: assetCollection, options: options)
                            
                            if result.count > 0 {
                                var items = [PHAsset]()
                                result.enumerateObjects({ (asset, index, nil) in
                                    items.append(asset)
                                })
                                 
                                let group = ZZPhotoGroupModel.init(assetCollection: assetCollection, assets: items)
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
