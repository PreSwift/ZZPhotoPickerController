//
//  ZZPhotoPlaceholderView.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 27/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit

class ZZPhotoPlaceholderView: UIView {

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.regular)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.light)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true
        backgroundColor = UIColor.white
        
        let containerView = UIView()
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().inset(30)
        }
        
        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
        }
        
        containerView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.greaterThanOrEqualToSuperview()
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeStatus(type: ZZPhotoOperationStatus) {
        DispatchQueue.main.async {
            if type == .normal {
                self.isHidden = true
            } else {
                self.isHidden = false
                if type == .noPermission {
                    self.titleLabel.text = "无访问权限"
                    self.contentLabel.text = "您可以进入手机的 设置-隐私-\(Bundle.main.infoDictionary!["CFBundleDisplayName"]!) 选择 允许读取和写入。"
                } else {
                    self.titleLabel.text = "无照片或视频"
                    self.contentLabel.text = "您可以使用相机拍摄照片或视频，或使用 iTunes 将照片和视频同步到 iPhone。"
                }
            }
        }
    }
    
}
