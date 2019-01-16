//
//  ZZPhotoBrowserCollectionViewCell.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 15/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import QMUIKit

class ZZPhotoBrowserCollectionViewCell: UICollectionViewCell {
    
    static let cellID = NSStringFromClass(ZZPhotoBrowserCollectionViewCell.self)
    
    var representedAssetIdentifier: String!
    private(set) var imageView: QMUIZoomImageView!
    private(set) lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView.init(style: .gray)
        indicator.hidesWhenStopped = true
        contentView.addSubview(indicator)
        indicator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        return indicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = QMUIZoomImageView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        contentView.addSubview(imageView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
