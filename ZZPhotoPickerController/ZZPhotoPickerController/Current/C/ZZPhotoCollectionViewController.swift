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
import SnapKit

class ZZPhotoCollectionViewController: UIViewController {

    var leftItem: UIBarButtonItem!
    var rightButton: UIButton!
    var titleBtn: UIButton!
    var itemWidth = (UIScreen.main.bounds.width - 3) / 4
    var collectionView: UICollectionView!
    var titleView: UIButton!
    lazy var placeholderView: ZZPhotoPlaceholderView = {
        let placeholderView = ZZPhotoPlaceholderView()
        view.addSubview(placeholderView)
        placeholderView.snp.makeConstraints { (make) in
            make.edges.equalTo(collectionView)
        }
        return placeholderView
    }()
    var mediaType: ZZPhotoPickerMediaType = .image
    var maxSelectCount: Int = 9999
    lazy var toolView: ZZPhotoToolView = ZZPhotoToolView()
    var collectionViewModel: ZZPhotoCollectionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // UI
        leftItem = UIBarButtonItem.init(barButtonSystemItem: .cancel, target: nil, action: nil)
        leftItem.tintColor = UIColor.darkText
        navigationItem.leftBarButtonItem = leftItem
        
        rightButton = UIButton.init(frame: CGRect.init(x: 0, y: 0, width: 60, height: 44))
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        rightButton.contentEdgeInsets = UIEdgeInsetsMake(2, 4, 2, 4)
        rightButton.layer.cornerRadius = 2
        rightButton.layer.masksToBounds = true
        rightButton.setBackgroundImage(UIImage.init(color: UIColor.orange), for: .normal)
        rightButton.setBackgroundImage(UIImage.init(color: UIColor.clear), for: .disabled)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.setTitleColor(UIColor.init(hex: "#dcdcdc"), for: .disabled)
        rightButton.isEnabled = false
        rightButton.snp.makeConstraints { (make) in }
        let rightItem = UIBarButtonItem.init(customView: rightButton)
        
        titleBtn = UIButton()
        titleBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.bold)
        titleBtn.setTitleColor(UIColor.orange, for: .normal)
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
        
        
        if mediaType == .video {
            navigationItem.rightBarButtonItem = nil
            collectionView.snp.makeConstraints { (make) in
                if #available(iOS 11.0, *) {
                    make.edges.equalTo(view.safeAreaLayoutGuide)
                } else {
                    make.edges.equalToSuperview()
                }
            }
        } else {
            navigationItem.rightBarButtonItem = rightItem
            collectionView.snp.makeConstraints { (make) in
                if #available(iOS 11.0, *) {
                    make.top.left.right.equalTo(view.safeAreaLayoutGuide)
                } else {
                    make.top.left.right.equalToSuperview()
                }
            }
            
            view.addSubview(toolView)
            toolView.snp.makeConstraints { (make) in
                make.top.equalTo(collectionView.snp.bottom)
                if #available(iOS 11.0, *) {
                    make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
                } else {
                    make.left.right.bottom.equalToSuperview()
                }
            }
        }
        
        // VM
        let photoOperationService = ZZPhotoOperationService.init(mediaType: mediaType, maxSelectCount: maxSelectCount)
        collectionViewModel = ZZPhotoCollectionViewModel.init(target: self, photoOperationService: photoOperationService)
    }
    
    deinit {
        print(self)
    }
    
}
