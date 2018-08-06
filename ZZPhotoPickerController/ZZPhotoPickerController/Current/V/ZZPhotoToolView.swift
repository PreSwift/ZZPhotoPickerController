//
//  ZZPhotoToolView.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 31/7/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import RxSwift

class ZZPhotoToolView: UIView {

    private var line: UIView!
    private(set) var previewBtn: UIButton!
    private(set) var cameraBtn: UIButton!
    
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
        
        cameraBtn = UIButton()
        cameraBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.regular)
        cameraBtn.setTitle("拍摄", for: .normal)
        cameraBtn.contentEdgeInsets = UIEdgeInsetsMake(4, 8, 4, 8)
        cameraBtn.layer.cornerRadius = 2
        cameraBtn.layer.masksToBounds = true
        cameraBtn.setBackgroundImage(UIImage.init(color: UIColor.orange), for: .normal)
        cameraBtn.setBackgroundImage(UIImage.init(color: UIColor.clear), for: .disabled)
        addSubview(cameraBtn)
        cameraBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changePreviewBtnStatus(isEnabled: Bool) {
        if isEnabled == true {
            previewBtn.isEnabled = true
            previewBtn.layer.borderColor = nil
            previewBtn.layer.borderWidth = 0
        } else {
            previewBtn.isEnabled = false
            previewBtn.layer.borderColor = UIColor.init(hex: "#dcdcdc").cgColor
            previewBtn.layer.borderWidth = 1
        }
    }
    
    deinit {
//        print(self)
    }
    
}
