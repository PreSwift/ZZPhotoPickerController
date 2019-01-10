//
//  ZZPhotoGroupTableViewCell.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 6/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import Photos
import SnapKit
import QMUIKit

class ZZPhotoGroupTableViewCell: UITableViewCell {

    static let cellID = NSStringFromClass(ZZPhotoGroupTableViewCell.self)
    
    var representedAssetIdentifier: String!
    
    private(set) var leftImageView: UIImageView!
    private(set) var selectedImageView: UIImageView!
    private(set) var titleLabel: UILabel!
    private(set) var numberLabel: UILabel!
    
    let iconWidth: CGFloat = 50
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFill
        leftImageView.clipsToBounds = true
        contentView.addSubview(leftImageView)
        leftImageView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: iconWidth, height: iconWidth))
            make.top.bottom.equalToSuperview().inset(8.0).priority(999)
            make.left.equalToSuperview().inset(separatorInset.left)
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.init(hex: "#333333")
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftImageView.snp.right).offset(10.0)
            make.centerY.equalTo(leftImageView)
        }
        
        numberLabel = UILabel()
        numberLabel.textColor = UIColor.init(hex: "#333333")
        numberLabel.font = UIFont.systemFont(ofSize: 12)
        contentView.addSubview(numberLabel)
        numberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel.snp.right).offset(10.0)
            make.bottom.equalTo(titleLabel)
        }
        
        selectedImageView = UIImageView()
        selectedImageView.image = UIImage.imageName(aClass: self, name: "zzphoto_photoGroup_select")
        leftImageView.addSubview(selectedImageView)
        selectedImageView.snp.makeConstraints { (make) in
            make.right.top.equalToSuperview().inset(3.0)
            make.size.equalTo(CGSize.init(width: 13, height: 13))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(group: ZZPhotoGroupModel) {
        let asset = group.assets[0]
        self.representedAssetIdentifier = asset.localIdentifier
        self.leftImageView.image = nil
        PHImageManager.default().requestImage(for: asset, targetSize: CGSize.init(width: iconWidth * UIScreen.main.scale, height: iconWidth * UIScreen.main.scale), contentMode: .default, options: nil) { [weak self] (image, info) in
            guard let strongSelf = self else { return }
            if image != nil && asset.localIdentifier == strongSelf.representedAssetIdentifier {
                self?.leftImageView.image = image
            }
        }
        titleLabel.text = group.assetCollection.localizedTitle
        numberLabel.text = "\(group.assets.count)"
        selectedImageView.isHidden = !group.isContainSelectedAssets
        self.isSelected = group.isCurrentGroup
    }
    
}
