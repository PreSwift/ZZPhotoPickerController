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
import QMUIKit

class ZZPhotoCollectionViewCell: UICollectionViewCell {
    
    static let cellID = NSStringFromClass(ZZPhotoCollectionViewCell.self)
    
    var representedAssetIdentifier: String!
    var disposeBag = DisposeBag()
    private(set) var imageView: UIImageView!
    private(set) var livePhotoBadgeView: UIImageView!
    private(set) var gifLabel: UILabel!
    private(set) var shadowView: UIView!
    private(set) var selectBtn: UIButton!
    private(set) lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(style: .gray)
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
        
        livePhotoBadgeView = UIImageView()
        livePhotoBadgeView.contentMode = .center
        contentView.addSubview(livePhotoBadgeView)
        livePhotoBadgeView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalTo(40.0)
            make.width.greaterThanOrEqualTo(40.0)
        }
        
        gifLabel = UILabel()
        gifLabel.text = "动图"
        gifLabel.textColor = UIColor.white
        gifLabel.backgroundColor = UIColor.init(red: 52.0/255, green: 126.0/255, blue: 224.0/255, alpha: 160.0/255)
        gifLabel.font = UIFont.systemFont(ofSize: 11)
        gifLabel.textAlignment = .center
        contentView.addSubview(gifLabel)
        gifLabel.snp.makeConstraints { (make) in
            make.right.bottom.equalToSuperview()
            make.size.equalTo(CGSize.init(width: 30, height: 20))
        }
        
        selectBtn = UIButton()
        selectBtn.setImage(UIImage.imageName(name: "zzphoto_photo_selected_small"), for: .selected)
        selectBtn.setImage(UIImage.imageName(name: "zzphoto_photo_not_selected_small"), for: .normal)
        selectBtn.contentEdgeInsets = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
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
