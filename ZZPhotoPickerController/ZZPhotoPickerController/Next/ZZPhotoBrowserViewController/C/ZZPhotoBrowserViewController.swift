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

    lazy var leftButton: UIButton = {
        let leftButton = UIButton()
        leftButton.setImage(#imageLiteral(resourceName: "ZZPhoto_nav_back").withRenderingMode(.alwaysTemplate), for: .normal)
        leftButton.contentHorizontalAlignment = .left
        leftButton.tintColor = UIColor.white
        return leftButton
    }()
    lazy var rightButton: UIButton = {
        let rightButton = UIButton()
        rightButton.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        rightButton.setTitle("下一步", for: .normal)
        rightButton.layer.cornerRadius = 15
        rightButton.layer.masksToBounds = true
        rightButton.setBackgroundImage(UIImage.init(color: UIColor.orange.withAlphaComponent(0.8)), for: .normal)
        rightButton.setTitleColor(UIColor.white, for: .normal)
        rightButton.contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10)
        return rightButton
    }()
    lazy var checkMark: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "ZZPhoto_selected_small"), for: .selected)
        button.setImage(#imageLiteral(resourceName: "ZZPhoto_selected_not_small"), for: .normal)
        return button
    }()
    lazy var flowLayout: ZZPhotoBrowserCollectionViewFlowLayout = {
        let flowLayout = ZZPhotoBrowserCollectionViewFlowLayout()
        return flowLayout
    }()
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView.init(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isDirectionalLockEnabled = true
        collectionView.decelerationRate = UIScrollViewDecelerationRateFast
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ZZPhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: ZZPhotoBrowserCollectionViewCell.cellID)
        return collectionView
    }()
    var viewModel: ZZPhotoBrowserViewModel!
    var pageIndex: Int = 0
    
    required init(photoOperationService: ZZPhotoOperationService, isPreview: Bool = false) {
        super.init(nibName: nil, bundle: nil)
        viewModel = ZZPhotoBrowserViewModel.init(target: self, photoOperationService: photoOperationService, isPreview: isPreview)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.init(white: 0.1, alpha: 1)

        // UI
        flowLayout.offsetX = (view.frame.width + flowLayout.itemSpacing) * CGFloat(pageIndex)
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.edges.equalTo(view.safeAreaLayoutGuide)
            } else {
                make.edges.equalToSuperview()
            }
        }
        
        view.addSubview(leftButton)
        leftButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            } else {
                make.top.equalToSuperview().inset(15)
            }
            make.left.equalToSuperview().inset(10)
            make.size.equalTo(CGSize.init(width: 60, height: 30))
        }
        
        view.addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                make.top.equalTo(view.safeAreaLayoutGuide).inset(15)
            } else {
                make.top.equalToSuperview().inset(15)
            }
            make.right.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        view.addSubview(checkMark)
        checkMark.snp.makeConstraints { (make) in
            make.top.equalTo(rightButton.snp.bottom).offset(10)
            make.right.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 40, height: 40))
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    deinit {
        print(self)
    }

}
