//
//  ZZPhotoCollectionViewModel.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import Photos
import RxSwift
import RxDataSources
import PhotosUI

class ZZPhotoCollectionViewModel: NSObject {
    
    var photoOperationService: ZZPhotoOperationService
    weak var target: ZZPhotoCollectionViewController!
    
    var result = PublishSubject<[SectionModel<String, PHAsset>]>()
    let disposeBag = DisposeBag()
    
    required init(target: ZZPhotoCollectionViewController, photoOperationService: ZZPhotoOperationService) {
        self.photoOperationService = photoOperationService
        super.init()
        self.target = target
        
        // 数据绑定UI
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PHAsset>> (
            configureCell: { [weak self] (dataSource, collectionView, indexPath, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZZPhotoCollectionViewCell.cellID, for: indexPath) as! ZZPhotoCollectionViewCell
                cell.representedAssetIdentifier = element.localIdentifier
                cell.imageView.image = nil

                guard let strongSelf = self else { return cell }
                
                let assets = strongSelf.photoOperationService.selectedAssets.value
                if assets.contains(element) {
                    cell.selectBtn.isSelected = true
                    cell.shadowView.isHidden = false
                } else {
                    cell.selectBtn.isSelected = false
                    cell.shadowView.isHidden = true
                }
                
                // Add a badge to the cell if the PHAsset represents a Live Photo.
                if #available(iOS 9.1, *) {
                    if element.mediaSubtypes.contains(.photoLive) {
                        cell.livePhotoBadgeView.image = PHLivePhotoView.livePhotoBadgeImage(options: .overContent)
                    } else {
                        cell.livePhotoBadgeView.image = nil
                    }
                } else {
                    cell.livePhotoBadgeView.image = nil
                }
                
                // Add a badge to the cell if the PHAsset represents a gif.
                if #available(iOS 11.0, *) {
                    if element.playbackStyle == .imageAnimated {
                        cell.gifLabel.isHidden = false
                    } else {
                        cell.gifLabel.isHidden = true
                    }
                } else {
                    cell.gifLabel.isHidden = true
                }

                //cell中按钮点击事件订阅
                cell.selectBtn.rx.tap.asDriver()
                    .drive(onNext: { [weak self] in
                        guard let strongSelf = self else { return }
                        var newAssets = strongSelf.photoOperationService.selectedAssets.value
                        if let index = newAssets.index(of: element) {
                            newAssets.remove(at: index)
                        } else {
                            let max = strongSelf.photoOperationService.maxSelectCount
                            if newAssets.count >= max {
                                ZZPhotoAlertView.show("最多可以选择\(max)张照片")
                            } else {
                                newAssets.append(element)
                            }
                        }
                        strongSelf.photoOperationService.selectedAssets.accept(newAssets)
                        collectionView.performBatchUpdates({
                            collectionView.reloadItems(at: [indexPath])
                        })
                    }).disposed(by: cell.disposeBag)


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
                PHImageManager.default().requestImage(for: element, targetSize: CGSize.init(width: strongSelf.target.itemWidth * UIScreen.main.scale, height: strongSelf.target.itemWidth * UIScreen.main.scale), contentMode: .default, options: options, resultHandler: { (image, _) in
                    if cell.representedAssetIdentifier == element.localIdentifier && image != nil {
                        cell.imageView.image = image
                    }
                })

                if element.mediaType.rawValue == PHAssetMediaType.video.rawValue {
                    cell.selectBtn.isHidden = true
                    cell.videoIndicatorView.isHidden = false

                    let minutes = Int(element.duration / 60.0)
                    let seconds = Int(ceil(element.duration - 60.0 * Double(minutes)))
                    cell.videoIndicatorView.timeLabel.text = String.init(format: "%02ld:%02ld", minutes, seconds)

                    if element.mediaSubtypes.rawValue & PHAssetMediaSubtype.videoHighFrameRate.rawValue != 0 {
                        cell.videoIndicatorView.videoIcon.isHidden = true
                        cell.videoIndicatorView.slomoIcon.isHidden = false
                    }
                    else {
                        cell.videoIndicatorView.videoIcon.isHidden = false
                        cell.videoIndicatorView.slomoIcon.isHidden = true
                    }
                } else {
                    cell.selectBtn.isHidden = false
                    cell.videoIndicatorView.isHidden = true
                }

                return cell
            }
        )

        // 监听dataSource
        result.bind(to: target.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        // 监听数据请求
        self.photoOperationService.rx.observeWeakly(ZZPhotoGroupModel.self, "currentGroup", options: [.new]).subscribe(onNext: { [weak self] (value) in
            guard let strongSelf = self else { return }
            if let newValue = value {
                let section = SectionModel.init(model: "1", items: newValue.assets)
                strongSelf.result.onNext([section])

                Observable.just(newValue.assetCollection.localizedTitle).map { [weak self] (value) -> String? in
                    if self?.photoOperationService.isGroupViewShow == true {
                        return value == nil ? nil : value! + " ▲"
                    } else {
                        return value == nil ? nil : value! + " ▼"
                    }
                }.bind(to: strongSelf.target.titleBtn.rx.title()).disposed(by: strongSelf.disposeBag)
            }
        }).disposed(by: disposeBag)

        self.photoOperationService.rx.observeWeakly(Bool.self, "isGroupViewShow", options: [.new]).subscribe(onNext: { [weak self] (value) in
            guard let strongSelf = self else { return }
            if let newValue = value {
                Observable.just(strongSelf.photoOperationService.currentGroup.assetCollection.localizedTitle).map { (value) -> String? in
                    if newValue == true {
                        return value == nil ? nil : value! + " ▲"
                    } else {
                        return value == nil ? nil : value! + " ▼"
                    }
                    }.bind(to: strongSelf.target.titleBtn.rx.title()).disposed(by: strongSelf.disposeBag)
            }
        }).disposed(by: disposeBag)

        // 监听服务状态
        self.photoOperationService.rx.observeWeakly(String.self, "operationStatusRaw").subscribe(onNext: { [weak self] (status) in
            guard let strongSelf = self else { return }
            if let newStatus = status {
                strongSelf.target.placeholderView.changeStatus(type: ZZPhotoOperationStatus.init(rawValue: newStatus)!)
            }
        }).disposed(by: disposeBag)

        // 监听UI事件
        (target.titleBtn.rx.tap).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            let groupView = ZZPhotoGroupView.init(photoOperationService: strongSelf.photoOperationService)
            groupView.show()
        }).disposed(by: disposeBag)

        (target.leftItem.rx.tap).subscribe(onNext: { [weak self] (_) in
            self?.target.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)

        (target.rightButton.rx.tap).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            if let rootVC = strongSelf.target.navigationController as? ZZPhotoPickerController {
                rootVC.zzDelegate?.photoPickerController!(rootVC, didSelect: strongSelf.photoOperationService.selectedAssets.value)
                rootVC.dismiss(animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)

        target.collectionView.rx.modelSelected(PHAsset.self).subscribe(onNext: { [weak self] (asset) in
            guard let strongSelf = self else { return }
            if asset.mediaType == .image {
                let vc = ZZPhotoBrowserViewController.init(photoOperationService: strongSelf.photoOperationService)
                if let index = strongSelf.photoOperationService.currentGroup.assets.index(of: asset) {
                    vc.pageIndex = index
                }
                strongSelf.target.navigationController?.pushViewController(vc, animated: true)
            } else if asset.mediaType == .video {
                let vc = ZZVideoPlayViewController.init(asset: asset)
                strongSelf.target.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
        
        target.collectionView.rx.modelSelected(PHAsset.self).take(1).subscribe(onNext: { (asset) in
            if asset.mediaType == .video {
                let options = PHVideoRequestOptions()
                options.isNetworkAccessAllowed = true
                PHImageManager.default().requestAVAsset(forVideo: asset, options: options, resultHandler: { (avAsset, audioMix, info) in

                })
            }
        }).disposed(by: disposeBag)

        // 监听选中改变预览按钮状态
        photoOperationService.selectedAssets.bind { [weak self] assets in
            guard let strongSelf = self else { return }
            let isEnabled = assets.count > 0 ? true : false
            strongSelf.target.toolView.changePreviewBtnStatus(isEnabled: isEnabled)
            strongSelf.target.rightButton.isEnabled = isEnabled
            if isEnabled {
                strongSelf.target.rightButton.setTitle("下一步(\(assets.count))", for: .normal)
                strongSelf.target.rightButton.layer.borderColor = nil
                strongSelf.target.rightButton.layer.borderWidth = 0
            } else {
                strongSelf.target.rightButton.setTitle("下一步", for: .normal)
                strongSelf.target.rightButton.layer.borderColor = UIColor.init(hex: "#dcdcdc").cgColor
                strongSelf.target.rightButton.layer.borderWidth = 1
            }
        }.disposed(by: target.toolView.disposeBag)

        // 预览按钮点击事件
        target.toolView.previewBtn.rx.tap.bind { [weak self] in
            guard let strongSelf = self else { return }
            let vc = ZZPhotoBrowserViewController.init(photoOperationService: strongSelf.photoOperationService, isPreview: true)
            strongSelf.target.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)

        // 拍摄按钮点击事件
        target.toolView.ytBtn.rx.tap.bind { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.target.toolView.changeYtBtnStatus(isSelected: !strongSelf.target.toolView.ytBtn.isSelected)
        }.disposed(by: disposeBag)
        
        
        
        
        // 注册3DTouch
        if self.target.traitCollection.forceTouchCapability == .available {
            self.target.registerForPreviewing(with: self, sourceView: self.target.collectionView)
        }
    }
    
    deinit {
        print(self)
    }
}

extension ZZPhotoCollectionViewModel: UIViewControllerPreviewingDelegate {
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = self.target.collectionView.indexPathForItem(at: location) {
            let asset = photoOperationService.currentGroup.assets[indexPath.item]
            if let cell = self.target.collectionView.cellForItem(at: indexPath) {
                previewingContext.sourceRect = cell.frame
                
                if asset.mediaType == .video {
                    let vc = ZZVideoPlayViewController.init(asset: asset)
                    vc.preferredContentSize = CGSize.init(width: CGFloat(asset.pixelWidth) / UIScreen.main.scale, height: CGFloat(asset.pixelHeight) / UIScreen.main.scale)
                    return vc
                } else {
                    let vc = ZZPhoto3DTouchViewController.init(asset: asset)
                    vc.preferredContentSize = CGSize.init(width: CGFloat(asset.pixelWidth) / UIScreen.main.scale, height: CGFloat(asset.pixelHeight) / UIScreen.main.scale)
                    return vc
                }
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        if let imageVC = viewControllerToCommit as? ZZPhoto3DTouchViewController {
            let asset = imageVC.asset
            let vc = ZZPhotoBrowserViewController.init(photoOperationService: photoOperationService)
            if let index = photoOperationService.currentGroup.assets.index(of: asset) {
                vc.pageIndex = index
            }
            self.target.show(vc, sender: self.target)
        } else {
            self.target.show(viewControllerToCommit, sender: self.target)
        }
    }
    
    
}
