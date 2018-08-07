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
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZZPhotoBrowserCollectionViewCell.cellID, for: indexPath) as! ZZPhotoBrowserCollectionViewCell
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
        
        // 处理UI事件
        target.collectionView.rx.didScroll.map { [weak self] (_) -> Int in
            guard let strongSelf = self else { return 0 }
            return Int((strongSelf.target.collectionView.contentOffset.x + strongSelf.target.collectionView.bounds.width / 2) / (strongSelf.target.collectionView.bounds.width + strongSelf.target.flowLayout.itemSpacing))
        }.bind { [weak self] (page) in
            guard let strongSelf = self else { return  }
            strongSelf.target.pageIndex = page
            if strongSelf.isPreview {
                strongSelf.target.navigationItem.title = "\(page + 1)/\(strongSelf.previewAssets.count)"
            } else {
                strongSelf.target.navigationItem.title = "\(page + 1)/\(strongSelf.photoOperationService.currentGroup.assets.count)"
            }
        }.disposed(by: disposeBag)
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
