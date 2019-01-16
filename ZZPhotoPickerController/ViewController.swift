//
//  ViewController.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 25/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit
import RxCocoa
import Photos

class ViewController: UIViewController {

    var collectionView: UICollectionView!
    var rightItem = UIBarButtonItem.init(barButtonSystemItem: .camera, target: nil, action: nil)
    var assets = [PHAsset]()
    
    @objc dynamic var message = "hangge.com"
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        navigationItem.title = "照片选择器"
        navigationItem.rightBarButtonItem = rightItem

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 5
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = UIEdgeInsets.init(top: 5, left: 5, bottom: 5, right: 5)
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.cellID)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        _ = (rightItem.rx.tap).bind { [unowned self] in
            let vc = ZZPhotoPickerController()
            vc.maxSelectCount = 1
            self.present(vc, animated: true, completion: nil)
            vc.rx.assetsSelected.subscribe(onNext: { [unowned self] (assets) in
                self.assets += (assets as![PHAsset])
                self.collectionView.reloadData()
            }).disposed(by: self.disposeBag)
        }
        
        
    }


}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.cellID, for: indexPath) as! CollectionViewCell
        let asset = assets[indexPath.item]
        cell.representedAssetIdentifier = asset.localIdentifier
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, _, _, _) in
            if cell.representedAssetIdentifier == asset.localIdentifier && data != nil {
                let image = UIImage.init(data: data!)
                cell.imageView.image = image
            }
        })
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 15) / 2
        return CGSize.init(width: itemWidth, height: itemWidth * 16 / 9)
    }
    
}
