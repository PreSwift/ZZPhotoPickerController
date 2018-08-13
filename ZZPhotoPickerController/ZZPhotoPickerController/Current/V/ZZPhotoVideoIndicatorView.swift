//
//  ZZPhotoVideoIndicatorView.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 6/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import SnapKit

class ZZPhotoVideoIndicatorView: UIView {

    private(set) lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        self.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(5)
            make.left.equalTo(self.videoIcon.snp.right).offset(4)
        })
        return label
    }()
    
    private(set) lazy var videoIcon: ZZPhotoVideoIconView = {
       let view = ZZPhotoVideoIconView()
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 14, height: 8))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(5)
        }
        return view
    }()
    
    private(set) lazy var slomoIcon: ZZPhotoSlomoIconView = {
        let view = ZZPhotoSlomoIconView()
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize.init(width: 12, height: 12))
            make.top.equalTo(self.videoIcon).offset(-3)
            make.left.equalToSuperview().inset(5)
        }
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Add gradient layer
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
