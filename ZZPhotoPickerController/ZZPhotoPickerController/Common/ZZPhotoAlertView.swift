//
//  ZZPhotoAlertView.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 7/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit
import SnapKit

var alertView: ZZPhotoAlertView?

class ZZPhotoAlertView: UIView {

    fileprivate var textView: UILabel?
    
    public static func show(_ message: String) {
        let alert = ZZPhotoAlertView()
        alert.textView?.text = message
        NotificationCenter.default.post(name: .alertViewChanged, object: ["obj", alert])
        
        let currentWindow = UIApplication.shared.keyWindow
        currentWindow?.addSubview(alert)
        
        alert.snp.makeConstraints { (make) in
            make.left.greaterThanOrEqualTo(15)
            make.center.equalToSuperview()
        }
        
        UIView.animate(withDuration: 1.0, delay: 1.5, options: .curveEaseInOut, animations: {
            alert.alpha = 0.0
        }) { (finished) in
            alert.removeFromSuperview()
        }
        
        alertView = alert
    }
    
    public static func hide() {
        if let _alertView = alertView {
            _alertView.superview?.removeFromSuperview()
            _alertView.removeFromSuperview()
        }
    }
    
    private init() {
        super.init(frame: .zero)
        NotificationCenter.default.addObserver(self, selector: #selector(dismiss(notification:)), name: .alertViewChanged, object: nil)
        
        backgroundColor = UIColor.init(white: 0.0, alpha: 0.8)
        layer.cornerRadius = 5
        layer.masksToBounds = true
        isUserInteractionEnabled = false
        
        textView = UILabel()
        textView!.font = UIFont.systemFont(ofSize: 15)
        textView!.textColor = .white
        textView!.numberOfLines = 0
        addSubview(textView!)
        textView!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets.init(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func dismiss(notification: Notification) {
        if notification.userInfo?["obj"] as? ZZPhotoAlertView != self {
            ZZPhotoAlertView.hide()
        }
    }

}
