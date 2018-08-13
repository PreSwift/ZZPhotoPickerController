//
//  ZZPhotoToolView.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 31/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift
import SnapKit

class ZZPhotoToolView: UIView {

    private var line: UIView!
    private(set) var previewBtn: UIButton!
    private(set) var ytBtn: UIButton!
    
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        line = UIView()
        line.backgroundColor = UIColor.init(r: 221.0, g: 221.0, b: 221.0, a: 1.0)
        addSubview(line)
        line.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        previewBtn = UIButton()
        previewBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        previewBtn.setTitle("预览", for: .normal)
        previewBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8)
        previewBtn.layer.cornerRadius = 2
        previewBtn.layer.masksToBounds = true
        previewBtn.setBackgroundImage(UIImage.init(color: UIColor.orange), for: .normal)
        previewBtn.setBackgroundImage(UIImage.init(color: UIColor.clear), for: .disabled)
        previewBtn.setTitleColor(UIColor.white, for: .normal)
        previewBtn.setTitleColor(UIColor.init(hex: "#dcdcdc"), for: .disabled)
        previewBtn.isEnabled = false
        addSubview(previewBtn)
        previewBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(15)
        }
        
        ytBtn = UIButton()
        ytBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        ytBtn.setTitle("原图", for: .normal)
        ytBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8)
        ytBtn.layer.cornerRadius = 2
        ytBtn.layer.masksToBounds = true
        ytBtn.layer.borderColor = UIColor.init(hex: "#dcdcdc").cgColor
        ytBtn.layer.borderWidth = 1
        ytBtn.setBackgroundImage(UIImage.init(color: UIColor.orange), for: .selected)
        ytBtn.setBackgroundImage(UIImage.init(color: UIColor.clear), for: .normal)
        ytBtn.setTitleColor(UIColor.white, for: .selected)
        ytBtn.setTitleColor(UIColor.init(hex: "#dcdcdc"), for: .normal)
        addSubview(ytBtn)
        ytBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changePreviewBtnStatus(isEnabled: Bool) {
        previewBtn.isEnabled = isEnabled
        if isEnabled == true {
            previewBtn.layer.borderColor = nil
            previewBtn.layer.borderWidth = 0
        } else {
            previewBtn.layer.borderColor = UIColor.init(hex: "#dcdcdc").cgColor
            previewBtn.layer.borderWidth = 1
        }
    }
    
    func changeYtBtnStatus(isSelected: Bool) {
        ytBtn.isSelected = isSelected
        if isSelected == true {
            ytBtn.layer.borderColor = nil
            ytBtn.layer.borderWidth = 0
        } else {
            ytBtn.layer.borderColor = UIColor.init(hex: "#dcdcdc").cgColor
            ytBtn.layer.borderWidth = 1
        }
    }
    
    deinit {
//        print(self)
    }
    
}
