//
//  ZZPhotoCollectionViewCell.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 26/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class ZZPhotoCollectionViewCell: UICollectionViewCell {
    
    static let cellID = NSStringFromClass(ZZPhotoCollectionViewCell.self)
    
    var representedAssetIdentifier: String!
    var disposeBag = DisposeBag()
    private(set) var imageView: UIImageView!
    private(set) var shadowView: UIView!
    private(set) var selectBtn: UIButton!
    private(set) lazy var videoIndicatorView: ZZPhotoVideoIndicatorView = {
        let view = ZZPhotoVideoIndicatorView.init(frame: CGRect.init(x: 0, y: self.bounds.maxY - 20, width: self.bounds.width, height: 20))
        contentView.addSubview(view)
        return view
    }()
    private(set) lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(activityIndicatorStyle: .gray)
        indicator.hidesWhenStopped = true
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        return indicator
    }()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        shadowView = UIView()
        shadowView.backgroundColor = UIColor.init(white: 0, alpha: 0.3)
        contentView.addSubview(shadowView)
        shadowView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        selectBtn = UIButton()
        selectBtn.setImage(UIImage.init(named: "ZZPhoto_selected_small", in: imageBundle, compatibleWith: nil), for: .selected)
        selectBtn.setImage(UIImage.init(named: "ZZPhoto_selected_not_small", in: imageBundle, compatibleWith: nil), for: .normal)
        selectBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
        contentView.addSubview(selectBtn)
        selectBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.top.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
