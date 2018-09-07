//
//  ZZPhotoBrowserViewModel.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxCocoa
import RxDataSources

class ZZPhotoBrowserViewModel: NSObject {

    var photoOperationService: ZZPhotoOperationService
    weak var target: ZZPhotoBrowserViewController!
    
    var isPreview: Bool
    lazy var previewAssets = [PHAsset]()
    var result = PublishSubject<[SectionModel<String, PHAsset>]>()
    let disposeBag = DisposeBag()
    
    required init(target: ZZPhotoBrowserViewController, photoOperationService: ZZPhotoOperationService, isPreview: Bool) {
        self.photoOperationService = photoOperationService
        self.isPreview = isPreview
        super.init()
        self.target = target
        
        // 数据绑定UI
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PHAsset>> (
            configureCell: { (dataSource, collectionView, indexPath, element) in
                if #available(iOS 9.1, *) {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZZPhotoBrowserLivePhotoCollectionViewCell.cellID, for: indexPath) as! ZZPhotoBrowserLivePhotoCollectionViewCell
                    cell.representedAssetIdentifier = element.localIdentifier
                    cell.imageView.image = nil
                    if element.mediaSubtypes.contains(.photoLive) {
                        cell.isLivePhoto = true
                        cell.imageView.stopAnimating()
                        cell.imageView.animationImages = nil
                        
                        let options = PHLivePhotoRequestOptions()
                        options.isNetworkAccessAllowed = true
                        options.progressHandler = { (progress, error, stop, info) in
                            DispatchQueue.main.async {
                                if progress < 1 {
                                    if cell.indicator.isAnimating == false {
                                        cell.indicator.startAnimating()
                                    }
                                } else {
                                    cell.indicator.stopAnimating()
                                }
                            }
                        }
                        PHImageManager.default().requestLivePhoto(for: element, targetSize: collectionView.frame.size, contentMode: .aspectFit, options: options) { (livePhoto, _) in
                            if cell.representedAssetIdentifier == element.localIdentifier && livePhoto != nil {
                                cell.livePhotoView.livePhoto = livePhoto
                            }
                        }
                    } else {
                        cell.isLivePhoto = false
                        if #available(iOS 11.0, *) {
                            if element.playbackStyle == .imageAnimated {
                                cell.imageView.image = nil
                                
                                let options = PHImageRequestOptions()
                                options.isNetworkAccessAllowed = true
                                options.progressHandler = { (progress, error, stop, info) in
                                    DispatchQueue.main.async {
                                        if progress < 1 {
                                            if cell.indicator.isAnimating == false {
                                                cell.indicator.startAnimating()
                                            }
                                        } else {
                                            cell.indicator.stopAnimating()
                                        }
                                    }
                                }
                                PHImageManager.default().requestImageData(for: element, options: options, resultHandler: { (data, _, _, _) in
                                    if cell.representedAssetIdentifier == element.localIdentifier && data != nil {
                                        self.getGifImagesFrom(data: data!, completion: { (images, duration) in
                                            if cell.representedAssetIdentifier == element.localIdentifier {
                                                cell.imageView.animationImages = images
                                                cell.imageView.animationDuration = duration
                                                cell.imageView.animationRepeatCount = 0 // 无限循环
                                                cell.imageView.startAnimating()
                                            }
                                        })
                                    }
                                })
                            } else {
                                cell.imageView.stopAnimating()
                                cell.imageView.animationImages = nil
                                
                                let options = PHImageRequestOptions()
                                options.isNetworkAccessAllowed = true
                                options.progressHandler = { (progress, error, stop, info) in
                                    DispatchQueue.main.async {
                                        if progress < 1 {
                                            if cell.indicator.isAnimating == false {
                                                cell.indicator.startAnimating()
                                            }
                                        } else {
                                            cell.indicator.stopAnimating()
                                        }
                                    }
                                }
                                PHImageManager.default().requestImageData(for: element, options: options, resultHandler: { (data, _, _, _) in
                                    if cell.representedAssetIdentifier == element.localIdentifier && data != nil {
                                        let image = UIImage.init(data: data!)
                                        cell.imageView.image = image
                                    }
                                })
                            }
                        } else {
                            cell.imageView.stopAnimating()
                            cell.imageView.animationImages = nil
                            
                            let options = PHImageRequestOptions()
                            options.isNetworkAccessAllowed = true
                            options.progressHandler = { (progress, error, stop, info) in
                                DispatchQueue.main.async {
                                    if progress < 1 {
                                        if cell.indicator.isAnimating == false {
                                            cell.indicator.startAnimating()
                                        }
                                    } else {
                                        cell.indicator.stopAnimating()
                                    }
                                }
                            }
                            PHImageManager.default().requestImageData(for: element, options: options, resultHandler: { (data, _, _, _) in
                                if cell.representedAssetIdentifier == element.localIdentifier && data != nil {
                                    let image = UIImage.init(data: data!)
                                    cell.imageView.image = image
                                }
                            })
                        }
                    }
                    return cell
                } else {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZZPhotoBrowserNormalCollectionViewCell.cellID, for: indexPath) as! ZZPhotoBrowserNormalCollectionViewCell
                    cell.representedAssetIdentifier = element.localIdentifier
                    cell.imageView.image = nil
                    let options = PHImageRequestOptions()
                    options.isNetworkAccessAllowed = true
                    options.progressHandler = { (progress, error, stop, info) in
                        DispatchQueue.main.async {
                            if progress < 1 {
                                if cell.indicator.isAnimating == false {
                                    cell.indicator.startAnimating()
                                }
                            } else {
                                cell.indicator.stopAnimating()
                            }
                        }
                    }
                    PHImageManager.default().requestImageData(for: element, options: options, resultHandler: { (data, _, _, _) in
                        if cell.representedAssetIdentifier == element.localIdentifier && data != nil {
                            let image = UIImage.init(data: data!)
                            cell.imageView.image = image
                        }
                    })
                    return cell
                }
            }
        )
        
        target.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // 监听dataSource
        result.bind(to: target.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        if isPreview {
            previewAssets += photoOperationService.selectedAssets.value
            let section = SectionModel.init(model: "1", items: previewAssets)
            result.onNext([section])
        } else {
            let section = SectionModel.init(model: "1", items: photoOperationService.currentGroup.assets)
            result.onNext([section])
        }
        
        // 监听选中改变预览按钮状态
        photoOperationService.selectedAssets.bind { [weak self] assets in
            guard let strongSelf = self else { return }
            let isEnabled = assets.count > 0 ? true : false
            if isEnabled {
                strongSelf.target.rightButton.setTitle("下一步(\(assets.count))", for: .normal)
            } else {
                strongSelf.target.rightButton.setTitle("下一步", for: .normal)
            }
            
            var asset: PHAsset!
            if strongSelf.isPreview {
                asset = strongSelf.previewAssets[strongSelf.target.pageIndex]
            } else {
                asset = strongSelf.photoOperationService.currentGroup.assets[strongSelf.target.pageIndex]
            }
            let newAssets = strongSelf.photoOperationService.selectedAssets.value
            if let _ = newAssets.index(of: asset) {
                strongSelf.target.checkMark.isSelected = true
            } else {
                strongSelf.target.checkMark.isSelected = false
            }
        }.disposed(by: disposeBag)
        
        // 处理UI事件
        let ob1 = target.collectionView.rx.didEndDecelerating.asObservable()
        let ob2 = target.collectionView.rx.didScroll.take(1).delay(0.5, scheduler: MainScheduler.asyncInstance).asObservable()
        
        ControlEvent<Void>.merge([ob1, ob2]).map { [weak self] (_) -> Int in
            guard let strongSelf = self else { return 0 }
            return Int((strongSelf.target.collectionView.contentOffset.x + strongSelf.target.collectionView.bounds.width / 2) / (strongSelf.target.collectionView.bounds.width + strongSelf.target.flowLayout.itemSpacing))
        }.bind { [weak self] (page) in
            guard let strongSelf = self else { return  }
            let cell = strongSelf.target.collectionView.cellForItem(at: IndexPath.init(item: page, section: 0))
            if #available(iOS 9.1, *) {
                if let livePhotoCell = cell as? ZZPhotoBrowserLivePhotoCollectionViewCell {
                    livePhotoCell.livePhotoView.startPlayback(with: .full)
                }
            }
        }.disposed(by: disposeBag)
        
        target.collectionView.rx.didScroll.map { [weak self] (_) -> Int in
            guard let strongSelf = self else { return 0 }
            return Int((strongSelf.target.collectionView.contentOffset.x + strongSelf.target.collectionView.bounds.width / 2) / (strongSelf.target.collectionView.bounds.width + strongSelf.target.flowLayout.itemSpacing))
        }.bind { [weak self] (page) in
            guard let strongSelf = self else { return  }
            strongSelf.target.pageIndex = page
            if strongSelf.isPreview {
                let asset = strongSelf.previewAssets[page]
                if strongSelf.photoOperationService.selectedAssets.value.contains(asset) {
                    strongSelf.target.checkMark.isSelected = true
                } else {
                    strongSelf.target.checkMark.isSelected = false
                }
            } else {
                let asset = strongSelf.photoOperationService.currentGroup.assets[page]
                if strongSelf.photoOperationService.selectedAssets.value.contains(asset) {
                    strongSelf.target.checkMark.isSelected = true
                } else {
                    strongSelf.target.checkMark.isSelected = false
                }
            }
        }.disposed(by: disposeBag)
        
        (target.leftButton.rx.tap).subscribe(onNext: { [weak self] (_) in
            self?.target.navigationController?.popViewController(animated: true)
        }).disposed(by: disposeBag)
        
        (target.rightButton.rx.tap).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            if let rootVC = strongSelf.target.navigationController as? ZZPhotoPickerController {
                rootVC.dismiss(animated: true, completion: {
                    var newAssets = strongSelf.photoOperationService.selectedAssets.value
                    if newAssets.count == 0 {
                        var asset: PHAsset!
                        if strongSelf.isPreview {
                            asset = strongSelf.previewAssets[strongSelf.target.pageIndex]
                        } else {
                            asset = strongSelf.photoOperationService.currentGroup.assets[strongSelf.target.pageIndex]
                        }
                        newAssets.append(asset)
                        strongSelf.photoOperationService.selectedAssets.accept(newAssets)
                    }
                    
                    rootVC.zzDelegate?.photoPickerController!(rootVC, didSelect: strongSelf.photoOperationService.selectedAssets.value)
                })
            }
        }).disposed(by: disposeBag)
        
        (target.checkMark.rx.tap).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            var asset: PHAsset!
            if strongSelf.isPreview {
                asset = strongSelf.previewAssets[strongSelf.target.pageIndex]
            } else {
                asset = strongSelf.photoOperationService.currentGroup.assets[strongSelf.target.pageIndex]
            }
            
            var newAssets = strongSelf.photoOperationService.selectedAssets.value
            if let index = newAssets.index(of: asset) {
                newAssets.remove(at: index)
            } else {
                let max = strongSelf.photoOperationService.maxSelectCount
                if newAssets.count >= max {
                    ZZPhotoAlertView.show("最多可以选择\(max)张照片")
                } else {
                    newAssets.append(asset)
                }
            }
            strongSelf.photoOperationService.selectedAssets.accept(newAssets)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        print(self)
    }
    
}

extension ZZPhotoBrowserViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}
