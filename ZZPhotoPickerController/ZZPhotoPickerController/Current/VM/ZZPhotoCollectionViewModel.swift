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

class ZZPhotoCollectionViewModel: NSObject {
    
    var photoOperationService = ZZPhotoOperationService()
    weak var target: ZZPhotoCollectionViewController!
    
    var result = PublishSubject<[SectionModel<String, PHAsset>]>()
    let disposeBag = DisposeBag()
    
    required init(target: ZZPhotoCollectionViewController) {
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
                
                //cell中按钮点击事件订阅
                cell.selectBtn.rx.tap.asDriver()
                    .drive(onNext: { [weak self] in
                        guard let strongSelf = self else { return }
                        var newAssets = strongSelf.photoOperationService.selectedAssets.value
                        if let index = newAssets.index(of: element) {
                            newAssets.remove(at: index)
                        } else {
                            newAssets.append(element)
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
                
                Observable.just(newValue.assetCollection.localizedTitle).bind(to: strongSelf.target.titleBtn.rx.title()).disposed(by: strongSelf.disposeBag)
            }
        }).disposed(by: disposeBag)
        
        // 监听服务状态
        self.photoOperationService.rx.observeWeakly(ZZPhotoOperationStatus.self, "operationStatus").subscribe(onNext: { [unowned self] (status) in
            if let newStatus = status {
                self.target.placeholderView.changeStatus(type: newStatus)
            }
        }).disposed(by: disposeBag)
        
        // 监听UI事件
        (target.leftItem.rx.tap).subscribe(onNext: { [weak self] (_) in
            self?.target.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        (target.rightItem.rx.tap).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            if let rootVC = strongSelf.target.navigationController as? ZZPhotoPickerController {
                rootVC.zzDelegate?.photoPickerController!(rootVC, didSelect: strongSelf.photoOperationService.selectedAssets.value)
                rootVC.dismiss(animated: true, completion: nil)
            }
        }).disposed(by: disposeBag)
        
        target.collectionView.rx.modelSelected(PHAsset.self).subscribe(onNext: { [weak self] (asset) in
            guard let strongSelf = self else { return }
            if strongSelf.photoOperationService.currentGroup != nil {
                let vc = ZZPhotoBrowserViewController.init(photoOperationService: strongSelf.photoOperationService)
                if let index = strongSelf.photoOperationService.currentGroup.imageAssets.index(of: asset) {
                    vc.pageIndex = index
                }
                strongSelf.target.navigationController?.pushViewController(vc, animated: true)
            }
        }).disposed(by: disposeBag)
        
        // 监听选中改变预览按钮状态
        photoOperationService.selectedAssets.map { (assets) -> Bool in
            assets.count > 0 ? true : false
            }.bind { [unowned self] isEnabled in
                self.target.toolView.changePreviewBtnStatus(isEnabled: isEnabled)
        }.disposed(by: target.toolView.disposeBag)
        
        // 预览按钮点击事件
        target.toolView.previewBtn.rx.tap.bind { [weak self] in
            guard let strongSelf = self else { return }
            let vc = ZZPhotoBrowserViewController.init(photoOperationService: strongSelf.photoOperationService, isPreview: true)
            strongSelf.target.navigationController?.pushViewController(vc, animated: true)
        }.disposed(by: disposeBag)
        
        // 拍摄按钮点击事件
        target.toolView.cameraBtn.rx.tap.bind {
            print("拍摄")
        }.disposed(by: disposeBag)
    }
    
    deinit {
        print(self)
    }
}
