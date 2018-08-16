//
//  ZZPhotoVideoIconView.swift
//  ZZPhotoPickerController
//
//  Created by WES319 on 6/8/18.
//  Copyright © 2018年 周元素. All rights reserved.
//

import UIKit

class ZZPhotoVideoIconView: UIView {

    var iconColor: UIColor = UIColor.white
    
    override func draw(_ rect: CGRect) {
        iconColor.setFill()
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint.init(x: bounds.maxX, y: bounds.minY))
        trianglePath.addLine(to: CGPoint.init(x: bounds.maxX, y: bounds.maxY))
        trianglePath.addLine(to: CGPoint.init(x: bounds.maxX - bounds.midY, y: bounds.midY))
        trianglePath.close()
        trianglePath.fill()
        
        let squarePath = UIBezierPath.init(roundedRect: CGRect.init(x: bounds.minX, y: bounds.minY, width: bounds.width - bounds.midY - 1.0, height: bounds.height), cornerRadius: 2.0)
        squarePath.fill()
    }
    
}
