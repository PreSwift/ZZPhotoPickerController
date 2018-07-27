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

    var photoOperationService: ZZPhotoOperationService!
    weak var target: ZZPhotoBrowserViewController!
    
    var result = PublishSubject<[SectionModel<String, PHAsset>]>()
    let disposeBag = DisposeBag()
    
    required init(target: ZZPhotoBrowserViewController, photoOperationService: ZZPhotoOperationService) {
        super.init()
        self.target = target
        self.photoOperationService = photoOperationService
        
        // 数据绑定UI
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PHAsset>> (
            configureCell: { (dataSource, collectionView, indexPath, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZZPhotoBrowserCollectionViewCell.cellID, for: indexPath) as! ZZPhotoBrowserCollectionViewCell
                cell.representedAssetIdentifier = element.localIdentifier
                let options = PHImageRequestOptions()
                options.isNetworkAccessAllowed = true
                options.progressHandler = { (progress, error, stop, info) in
                    DispatchQueue.main.async {
                        print(progress)
                        if progress < 1 && cell.indicator.isAnimating == false {
                            cell.indicator.startAnimating()
                        } else {
                            cell.indicator.stopAnimating()
                        }
                    }
                }
                PHImageManager.default().requestImageData(for: element, options: options, resultHandler: { (data, _, _, _) in
                    if cell.representedAssetIdentifier == element.localIdentifier && data != nil {
                        let image = UIImage.init(data: data!)
                        cell.imageView.image = image
                    } else {
                        cell.imageView.image = nil
                    }
                })
                return cell
            }
        )
        
        target.collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        // 监听dataSource
        result.bind(to: target.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        let section = SectionModel.init(model: "1", items: photoOperationService.currentGroup.imageAssets)
        result.onNext([section])
    }
    
}

extension ZZPhotoBrowserViewModel: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
    
}
