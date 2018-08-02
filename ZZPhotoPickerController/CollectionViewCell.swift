//
//  CollectionViewCell.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 2/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    static let cellID = NSStringFromClass(CollectionViewCell.self)
    
    var representedAssetIdentifier: String!
    private(set) var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
