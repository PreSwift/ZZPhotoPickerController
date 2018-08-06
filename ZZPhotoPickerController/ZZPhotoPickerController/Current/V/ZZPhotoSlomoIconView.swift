//
//  ZZPhotoSlomoIconView.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 6/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit

class ZZPhotoSlomoIconView: UIView {

    var iconColor: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        iconColor.setStroke()
        
        let width: CGFloat = 2.2
        let insetRect = rect.insetBy(dx: width / 2, dy: width / 2)
        
        let circlePath = UIBezierPath.init(ovalIn: insetRect)
        circlePath.lineWidth = width
        var ovalPattern: [CGFloat] = [0.75, 0.75]
        circlePath.setLineDash(&ovalPattern, count: 2, phase: 0)
        circlePath.stroke()
    }
    
}
