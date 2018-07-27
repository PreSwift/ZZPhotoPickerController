//
//  ZZPhotoBrowserViewController.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift

class ZZPhotoBrowserViewController: UIViewController {

    lazy var flowLayout: ZZPhotoBrowserCollectionViewFlowLayout = {
        let flowLayout = ZZPhotoBrowserCollectionViewFlowLayout()
        return flowLayout
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.isDirectionalLockEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ZZPhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: ZZPhotoBrowserCollectionViewCell.cellID)
        return collectionView
    }()
    var viewModel: ZZPhotoBrowserViewModel!
    
    required init(photoOperationService: ZZPhotoOperationService) {
        super.init(nibName: nil, bundle: nil)
        viewModel = ZZPhotoBrowserViewModel.init(target: self, photoOperationService: photoOperationService)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // UI
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
    }
    
    deinit {
        print(self)
    }

}
