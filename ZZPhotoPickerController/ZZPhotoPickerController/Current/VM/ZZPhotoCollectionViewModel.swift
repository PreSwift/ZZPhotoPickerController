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
    var result = PublishSubject<[SectionModel<String, PHAsset>]>()
    
    weak var target: ZZPhotoCollectionViewController!
    let disposeBag = DisposeBag()
    
    required init(target: ZZPhotoCollectionViewController) {
        super.init()
        self.target = target
        
        // 数据绑定UI
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, PHAsset>> (
            configureCell: { [weak self] (dataSource, collectionView, indexPath, element) in
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZZPhotoCollectionViewCell.cellID, for: indexPath) as! ZZPhotoCollectionViewCell
                guard let strongSelf = self else { return cell }
                PHImageManager.default().requestImage(for: element, targetSize: CGSize.init(width: strongSelf.target.itemWidth * UIScreen.main.scale, height: strongSelf.target.itemWidth * UIScreen.main.scale), contentMode: .default, options: nil, resultHandler: { (image, _) in
                    cell.imageView.image = image
                })
                return cell
            }
        )

        // 监听dataSource
        result.bind(to: target.collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)

        // 监听数据请求
        self.photoOperationService.rx.observeWeakly(ZZPhotoGroupModel.self, "currentGroup").subscribe(onNext: { [weak self] (value) in
            guard let strongSelf = self else { return }
            if let newValue = value {
                var items = [PHAsset]()
                newValue.fetchResult.enumerateObjects({ (asset, index, nil) in
                    items.append(asset)
                })
                
                let section = SectionModel.init(model: "1", items: items)
                strongSelf.result.onNext([section])
                
                Observable.just(newValue.assetCollection.localizedTitle).bind(to: strongSelf.target.titleBtn.rx.title()).disposed(by: strongSelf.disposeBag)
            }
        }).disposed(by: disposeBag)
        
        
        
        // 监听UI事件
        (target.leftItem.rx.tap).subscribe(onNext: { [weak self] (_) in
            self?.target.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        (target.rightItem.rx.tap).subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            let vc = ZZPhotoBrowserViewController.init(photoOperationService: strongSelf.photoOperationService)
            strongSelf.target.navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: disposeBag)
        
        target.collectionView.rx.modelSelected(PHAsset.self).subscribe(onNext: { (asset) in
            print(asset.localIdentifier)
        }).disposed(by: disposeBag)
    }
    
    deinit {
        print(self)
    }
}
