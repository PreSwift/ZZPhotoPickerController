//
//  ZZPhotoCollectionViewController.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class ZZPhotoCollectionViewController: UIViewController {

    var leftItem: UIBarButtonItem!
    var rightItem: UIBarButtonItem!
    var titleBtn: UIButton!
    var itemWidth = (UIScreen.main.bounds.width - 3) / 4
    var collectionView: UICollectionView!
    lazy var placeholderView: ZZPhotoPlaceholderView = {
        let placeholderView = ZZPhotoPlaceholderView()
        view.addSubview(placeholderView)
        placeholderView.snp.makeConstraints { (make) in
            make.edges.equalTo(collectionView)
        }
        return placeholderView
    }()
    var toolView: ZZPhotoToolView!
    var collectionViewModel: ZZPhotoCollectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // UI
        leftItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: nil, action: nil)
        rightItem = UIBarButtonItem.init(barButtonSystemItem: .done, target: nil, action: nil)
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        titleBtn = UIButton()
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        titleBtn.setTitleColor(UIColor.darkText, for: .normal)
        navigationItem.titleView = titleBtn
        titleBtn.snp.makeConstraints { (make) in
            make.size.greaterThanOrEqualTo(CGSize.init(width: 44, height: 44))
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 1
        flowLayout.minimumInteritemSpacing = 1
        flowLayout.itemSize = CGSize.init(width: itemWidth, height: itemWidth)
        collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ZZPhotoCollectionViewCell.self, forCellWithReuseIdentifier: ZZPhotoCollectionViewCell.cellID)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.top.left.right.equalToSuperview()
            }
        }

        toolView = ZZPhotoToolView()
        view.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.top.equalTo(collectionView.snp.bottom)
            if #available(iOS 11.0, *) {
                make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.left.right.bottom.equalToSuperview()
            }
        }
        
        // VM
        collectionViewModel = ZZPhotoCollectionViewModel.init(target: self)
    }

    deinit {
        print(self)
    }
    
}
